import 'dart:async';

import 'package:canteen_frontend/models/notification/notification.dart';
import 'package:canteen_frontend/models/notification/notification_repository.dart';
import 'package:canteen_frontend/models/post/post_repository.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/notifications/bloc/notification_list_event.dart';
import 'package:canteen_frontend/screens/notifications/bloc/notification_list_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quiver/iterables.dart';

class NotificationListBloc
    extends Bloc<NotificationListEvent, NotificationListState> {
  final UserRepository _userRepository;
  final NotificationRepository _notificationRepository;
  final PostRepository _postRepository;
  List<DetailedNotification> _notifications = [];
  DocumentSnapshot _lastNotification;
  StreamSubscription _latestNotificationSubscription;

  NotificationListBloc({
    @required UserRepository userRepository,
    @required NotificationRepository notificationRepository,
    @required PostRepository postRepository,
  })  : assert(userRepository != null),
        assert(notificationRepository != null),
        assert(postRepository != null),
        _userRepository = userRepository,
        _notificationRepository = notificationRepository,
        _postRepository = postRepository;

  @override
  NotificationListState get initialState => NotificationsUninitialized();

  @override
  Stream<NotificationListState> mapEventToState(
      NotificationListEvent event) async* {
    if (event is LoadNotifications) {
      yield* _mapLoadNotificationsToState(event);
    } else if (event is NotificationsUpdated) {
      yield* _mapNotificationsUpdatedToState(event);
    } else if (event is LoadOldNotifications) {
      yield* _mapLoadOldNotificationsToState(event);
    }
  }

  Stream<NotificationListState> _mapLoadNotificationsToState(
      LoadNotifications event) async* {
    try {
      _latestNotificationSubscription?.cancel();
      _latestNotificationSubscription = _notificationRepository
          .getLatestNotifications()
          .listen((notifications) {
        add(NotificationsUpdated(notifications));
      });
    } catch (exception) {
      print('ERROR: $exception');
    }
  }

  Stream<NotificationListState> _mapNotificationsUpdatedToState(
      NotificationsUpdated event) async* {
    final notifications = event.updates.item1;

    final userList = await Future.wait(notifications.map((notification) async {
      return _userRepository.getUser(notification.from);
    }));

    final detailedNotifications = zip([notifications, userList])
        .map((item) => DetailedNotification.fromNotification(item[0], item[1]))
        .toList();

    if (_lastNotification == null) {
      _lastNotification = event.updates.item2;
    }

    if (_notifications == null) {
      _notifications = detailedNotifications;
      yield NotificationsLoaded(notifications: detailedNotifications);
    } else {
      List<DetailedNotification> newNotificationList = [];
      newNotificationList.addAll(_notifications);

      detailedNotifications.forEach((newNotification) {
        final idx = newNotificationList.indexWhere(
            (notification) => notification.id == newNotification.id);

        if (idx == -1) {
          newNotificationList.insert(0, newNotification);
        } else if (newNotification.read) {
          newNotificationList[idx] = newNotification;
        } else {
          newNotificationList.removeAt(idx);

          var insertIdx = 0;
          while (insertIdx < newNotificationList.length) {
            if (newNotification.lastUpdated
                .isAfter(newNotificationList[insertIdx].lastUpdated)) {
              break;
            }
            insertIdx++;
          }

          newNotificationList.insert(insertIdx, newNotification);
        }
      });

      _notifications = newNotificationList;
      yield NotificationsLoaded(notifications: newNotificationList);
    }
  }

  Stream<NotificationListState> _mapLoadOldNotificationsToState(
      LoadOldNotifications event) async* {
    final notifications = await _notificationRepository.getNotifications(
        startAfterDocument: _lastNotification);

    final userList =
        await Future.wait(notifications.item1.map((notification) async {
      return _userRepository.getUser(notification.from);
    }));

    final detailedNotifications = zip([notifications.item1, userList])
        .map((item) => DetailedNotification.fromNotification(item[0], item[1]))
        .toList();

    _notifications.addAll(detailedNotifications);
    _lastNotification = notifications.item2;

    yield NotificationsLoaded(notifications: _notifications);
  }
}
