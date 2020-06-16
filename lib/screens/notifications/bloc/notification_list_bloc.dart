import 'dart:async';

import 'package:canteen_frontend/models/notification/notification.dart';
import 'package:canteen_frontend/models/notification/notification_repository.dart';
import 'package:canteen_frontend/models/post/post.dart';
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
  List<Notification> _notifications = [];
  DocumentSnapshot _lastNotification;

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
    }
  }

  Stream<NotificationListState> _mapLoadNotificationsToState(
      LoadNotifications event) async* {
    final notifications = await _notificationRepository.getNotifications();

    final userList =
        await Future.wait(notifications.item1.map((notification) async {
      return _userRepository.getUser(notification.from);
    }));

    final detailedNotifications = zip([notifications.item1, userList])
        .map((item) => DetailedNotification.fromNotification(item[0], item[1]))
        .toList();

    _notifications = detailedNotifications;
    _lastNotification = notifications.item2;

    yield NotificationsLoaded(notifications: _notifications);
  }
}
