import 'dart:async';

import 'package:canteen_frontend/models/notification/notification.dart';
import 'package:canteen_frontend/models/notification/notification_repository.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/notifications/bloc/notification_event.dart';
import 'package:canteen_frontend/screens/notifications/bloc/notification_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:quiver/iterables.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final UserRepository _userRepository;
  final NotificationRepository _notificationRepository;
  List<Notification> _notifications = [];
  DocumentSnapshot _lastNotification;

  NotificationBloc({
    @required UserRepository userRepository,
    @required NotificationRepository notificationRepository,
  })  : assert(userRepository != null),
        assert(notificationRepository != null),
        _userRepository = userRepository,
        _notificationRepository = notificationRepository;

  @override
  NotificationState get initialState => NotificationsUninitialized();

  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    if (event is LoadNotifications) {
      yield* _mapLoadNotificationsToState(event);
    }
  }

  Stream<NotificationState> _mapLoadNotificationsToState(
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
