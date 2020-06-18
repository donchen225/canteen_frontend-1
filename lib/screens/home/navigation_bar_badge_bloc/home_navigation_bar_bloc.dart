import 'dart:async';

import 'package:canteen_frontend/models/notification/notification.dart';
import 'package:canteen_frontend/screens/home/navigation_bar_badge_bloc/home_navigation_bar_event.dart';
import 'package:canteen_frontend/screens/home/navigation_bar_badge_bloc/home_navigation_bar_state.dart';
import 'package:canteen_frontend/screens/notifications/bloc/bloc.dart';
import 'package:canteen_frontend/screens/request/request_bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class HomeNavigationBarBadgeBloc
    extends Bloc<HomeNavigationBarBadgeEvent, HomeNavigationBarBadgeState> {
  final RequestBloc _requestBloc;
  final NotificationListBloc _notificationListBloc;
  StreamSubscription _requestSubscription;
  StreamSubscription _notificationSubscription;
  int _requestCount = 0;
  int _notificationCount = 0;
  DateTime _lastOpenedNotification;

  HomeNavigationBarBadgeBloc({
    @required RequestBloc requestBloc,
    @required NotificationListBloc notificationListBloc,
  })  : assert(requestBloc != null),
        assert(notificationListBloc != null),
        _requestBloc = requestBloc,
        _notificationListBloc = notificationListBloc {
    _requestSubscription = _requestBloc.listen((state) {
      if (state is RequestsLoaded) {
        add(UpdateRequestCount(numRequests: state.requestList.length));
      }
    });
    _notificationSubscription = _notificationListBloc.listen((state) {
      if (state is NotificationsLoaded) {
        add(UpdateNotificationCount(notifications: state.notifications));
      }
    });
  }

  @override
  HomeNavigationBarBadgeState get initialState =>
      HomeNavigationBarLoaded(numRequests: 0, numNotifications: 0);

  @override
  Stream<HomeNavigationBarBadgeState> mapEventToState(
      HomeNavigationBarBadgeEvent event) async* {
    if (event is LoadBadgeCounts) {
      yield* _mapLoadBadgeCountsToState();
    } else if (event is UpdateRequestCount) {
      yield* _mapUpdateRequestCountToState(event);
    } else if (event is UpdateNotificationCount) {
      yield* _mapUpdateNotificationCountToState(event);
    } else if (event is ReadNotificationCount) {
      yield* _mapReadNotificationCountToState();
    } else if (event is ClearBadgeCounts) {
      yield* _mapClearBadgeCountsToState();
    }
  }

  Stream<HomeNavigationBarBadgeState> _mapLoadBadgeCountsToState() async* {}

  Stream<HomeNavigationBarBadgeState> _mapUpdateRequestCountToState(
      UpdateRequestCount event) async* {
    _requestCount = event.numRequests;
    yield HomeNavigationBarLoaded(
      numRequests: event.numRequests,
      numNotifications: _notificationCount,
    );
  }

  Stream<HomeNavigationBarBadgeState> _mapUpdateNotificationCountToState(
      UpdateNotificationCount event) async* {
    final newNotifications = _lastOpenedNotification != null
        ? event.notifications.where((notification) =>
            !notification.read &&
            notification.lastUpdated.isAfter(_lastOpenedNotification))
        : event.notifications.where((notification) => !notification.read);

    final count = newNotifications.length;
    _notificationCount = count;

    yield HomeNavigationBarLoaded(
      numRequests: _requestCount,
      numNotifications: count,
    );
  }

  Stream<HomeNavigationBarBadgeState>
      _mapReadNotificationCountToState() async* {
    if (_notificationCount > 0) {
      _notificationCount = 0;
      _lastOpenedNotification = DateTime.now();
    }

    yield HomeNavigationBarLoaded(
      numRequests: _requestCount,
      numNotifications: 0,
    );
  }

  Stream<HomeNavigationBarBadgeState> _mapClearBadgeCountsToState() async* {
    yield HomeNavigationBarLoaded(
      numRequests: 0,
      numNotifications: 0,
    );
  }

  @override
  Future<void> close() {
    _requestSubscription?.cancel();
    _notificationSubscription?.cancel();
    return super.close();
  }
}
