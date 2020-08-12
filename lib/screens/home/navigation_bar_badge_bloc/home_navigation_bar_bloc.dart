import 'dart:async';

import 'package:canteen_frontend/screens/home/navigation_bar_badge_bloc/home_navigation_bar_event.dart';
import 'package:canteen_frontend/screens/home/navigation_bar_badge_bloc/home_navigation_bar_state.dart';
import 'package:canteen_frontend/screens/match/match_bloc/bloc.dart';
import 'package:canteen_frontend/screens/notifications/bloc/bloc.dart';
import 'package:canteen_frontend/screens/request/request_bloc/bloc.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class HomeNavigationBarBadgeBloc
    extends Bloc<HomeNavigationBarBadgeEvent, HomeNavigationBarBadgeState> {
  final MatchBloc _matchBloc;
  final RequestBloc _requestBloc;
  final NotificationListBloc _notificationListBloc;
  StreamSubscription _matchSubscription;
  StreamSubscription _requestSubscription;
  StreamSubscription _notificationSubscription;
  int messageCount = 0;
  int requestCount = 0;
  int notificationCount = 0;
  DateTime _lastOpenedNotification;

  HomeNavigationBarBadgeBloc({
    @required MatchBloc matchBloc,
    @required RequestBloc requestBloc,
    @required NotificationListBloc notificationListBloc,
  })  : assert(matchBloc != null),
        assert(requestBloc != null),
        assert(notificationListBloc != null),
        _matchBloc = matchBloc,
        _requestBloc = requestBloc,
        _notificationListBloc = notificationListBloc;

  @override
  HomeNavigationBarBadgeState get initialState =>
      HomeNavigationBarLoaded(numRequests: 0, numNotifications: 0);

  @override
  Stream<HomeNavigationBarBadgeState> mapEventToState(
      HomeNavigationBarBadgeEvent event) async* {
    if (event is LoadBadgeCounts) {
      yield* _mapLoadBadgeCountsToState();
    } else if (event is UpdateMessageCount) {
      yield* _mapUpdateMessageCountToState(event);
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

  Stream<HomeNavigationBarBadgeState> _mapLoadBadgeCountsToState() async* {
    _matchSubscription?.cancel();
    _requestSubscription?.cancel();
    _notificationSubscription?.cancel();

    _matchSubscription = _matchBloc.listen((state) {
      if (state is MatchesLoaded) {
        add(UpdateMessageCount(matches: state.matches));
      }
    });
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

  Stream<HomeNavigationBarBadgeState> _mapUpdateMessageCountToState(
      UpdateMessageCount event) async* {
    final userId =
        CachedSharedPreferences.getString(PreferenceConstants.userId);

    final unreadMessages = event.matches.where((m) {
      if (m.read == null) {
        return false;
      }

      final read = m.read[userId];

      if (read == null) {
        return false;
      } else {
        return !read;
      }
    });

    yield HomeNavigationBarLoaded(
      numMessages: unreadMessages.length,
      numRequests: requestCount,
      numNotifications: notificationCount,
    );
  }

  Stream<HomeNavigationBarBadgeState> _mapUpdateRequestCountToState(
      UpdateRequestCount event) async* {
    requestCount = event.numRequests;
    yield HomeNavigationBarLoaded(
      numMessages: messageCount,
      numRequests: event.numRequests,
      numNotifications: notificationCount,
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
    notificationCount = count;

    yield HomeNavigationBarLoaded(
      numMessages: messageCount,
      numRequests: requestCount,
      numNotifications: count,
    );
  }

  Stream<HomeNavigationBarBadgeState>
      _mapReadNotificationCountToState() async* {
    if (notificationCount > 0) {
      notificationCount = 0;
      _lastOpenedNotification = DateTime.now();
    }

    yield HomeNavigationBarLoaded(
      numMessages: messageCount,
      numRequests: requestCount,
      numNotifications: 0,
    );
  }

  Stream<HomeNavigationBarBadgeState> _mapClearBadgeCountsToState() async* {
    _matchSubscription?.cancel();
    _requestSubscription?.cancel();
    _notificationSubscription?.cancel();

    requestCount = 0;
    notificationCount = 0;
    _lastOpenedNotification = null;

    yield HomeNavigationBarLoaded(
      numMessages: 0,
      numRequests: 0,
      numNotifications: 0,
    );
  }

  @override
  Future<void> close() {
    _matchSubscription?.cancel();
    _requestSubscription?.cancel();
    _notificationSubscription?.cancel();
    return super.close();
  }
}
