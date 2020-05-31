import 'dart:async';

import 'package:canteen_frontend/screens/home/navigation_bar_badge_bloc/home_navigation_bar_event.dart';
import 'package:canteen_frontend/screens/home/navigation_bar_badge_bloc/home_navigation_bar_state.dart';
import 'package:canteen_frontend/screens/request/request_bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class HomeNavigationBarBadgeBloc
    extends Bloc<HomeNavigationBarBadgeEvent, HomeNavigationBarBadgeState> {
  final RequestBloc _requestBloc;
  StreamSubscription _requestSubscription;

  HomeNavigationBarBadgeBloc({@required RequestBloc requestBloc})
      : assert(requestBloc != null),
        _requestBloc = requestBloc {
    _requestSubscription = _requestBloc.listen((state) {
      if (state is RequestsLoaded) {
        add(UpdateBadgeCount(numRequests: state.requestList.length));
      }
    });
  }

  @override
  HomeNavigationBarBadgeState get initialState =>
      HomeNavigationBarLoaded(numRequests: 0);

  @override
  Stream<HomeNavigationBarBadgeState> mapEventToState(
      HomeNavigationBarBadgeEvent event) async* {
    if (event is LoadBadgeCounts) {
      yield* _mapLoadBadgeCountsToState();
    } else if (event is UpdateBadgeCount) {
      yield* _mapUpdateBadgeCountToState(event);
    } else if (event is ClearBadgeCounts) {
      yield* _mapClearBadgeCountsToState();
    }
  }

  Stream<HomeNavigationBarBadgeState> _mapLoadBadgeCountsToState() async* {}

  Stream<HomeNavigationBarBadgeState> _mapUpdateBadgeCountToState(
      UpdateBadgeCount event) async* {
    yield HomeNavigationBarLoaded(
      numRequests: event.numRequests,
      numRecommended: event.numRecommended,
    );
  }

  Stream<HomeNavigationBarBadgeState> _mapClearBadgeCountsToState() async* {
    yield HomeNavigationBarLoaded(
      numRequests: 0,
      numRecommended: 0,
    );
  }

  @override
  Future<void> close() {
    _requestSubscription?.cancel();
    return super.close();
  }
}
