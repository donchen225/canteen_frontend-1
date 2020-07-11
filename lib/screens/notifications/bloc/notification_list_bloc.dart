import 'dart:async';

import 'package:canteen_frontend/models/notification/notification.dart';
import 'package:canteen_frontend/models/notification/notification_repository.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/notifications/bloc/notification_list_event.dart';
import 'package:canteen_frontend/screens/notifications/bloc/notification_list_state.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quiver/iterables.dart';

class NotificationListBloc
    extends Bloc<NotificationListEvent, NotificationListState> {
  final UserRepository _userRepository;
  final NotificationRepository _notificationRepository;
  List<DetailedNotification> _notifications = [];
  int _currentPage = 0;
  DocumentSnapshot _lastNotification;
  StreamSubscription _latestNotificationSubscription;

  NotificationListBloc({
    @required UserRepository userRepository,
    @required NotificationRepository notificationRepository,
  })  : assert(userRepository != null),
        assert(notificationRepository != null),
        _userRepository = userRepository,
        _notificationRepository = notificationRepository;

  @override
  NotificationListState get initialState => NotificationsUnauthenticated();

  @override
  Stream<NotificationListState> mapEventToState(
      NotificationListEvent event) async* {
    if (event is LoadNotifications) {
      yield* _mapLoadNotificationsToState(event);
    } else if (event is NotificationsUpdated) {
      yield* _mapNotificationsUpdatedToState(event);
    } else if (event is LoadOldNotifications) {
      yield* _mapLoadOldNotificationsToState(event);
    } else if (event is ClearNotifications) {
      yield* _mapClearNotificationsToState();
    }
  }

  Stream<NotificationListState> _mapLoadNotificationsToState(
      LoadNotifications event) async* {
    yield NotificationsLoading();
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

    if (_notifications.isEmpty) {
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
    if (event.page > _currentPage) {
      final notifications = await _notificationRepository.getNotifications(
          startAfterDocument: _lastNotification, limit: postsPerPage);

      final userList =
          await Future.wait(notifications.item1.map((notification) async {
        return _userRepository.getUser(notification.from);
      }));

      final detailedNotifications = zip([notifications.item1, userList])
          .map(
              (item) => DetailedNotification.fromNotification(item[0], item[1]))
          .toList();

      List<DetailedNotification> newNotificationList = [];
      newNotificationList
        ..addAll(_notifications)
        ..addAll(detailedNotifications);

      _notifications = newNotificationList;
      _lastNotification = notifications.item2;
      _currentPage = event.page;

      yield NotificationsLoaded(notifications: newNotificationList);
    }
  }

  Stream<NotificationListState> _mapClearNotificationsToState() async* {
    _latestNotificationSubscription?.cancel();
    _notifications = [];
    _currentPage = 0;
    _lastNotification = null;
    yield NotificationsUnauthenticated();
  }

  @override
  Future<void> close() {
    _latestNotificationSubscription?.cancel();
    return super.close();
  }
}
