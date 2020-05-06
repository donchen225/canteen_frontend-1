import 'dart:async';

import 'package:canteen_frontend/screens/home/navigation_bar_bloc/home_navigation_bar_event.dart';
import 'package:canteen_frontend/screens/home/navigation_bar_bloc/home_navigation_bar_state.dart';
import 'package:canteen_frontend/screens/request/request_bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class HomeNavigationBarBloc
    extends Bloc<HomeNavigationBarEvent, HomeNavigationBarState> {
  StreamSubscription _requestSubscription;
  final RequestBloc _requestBloc;

  HomeNavigationBarBloc({@required RequestBloc requestBloc})
      : assert(requestBloc != null),
        _requestBloc = requestBloc {
    print('HomeNavigationBarBloc CONSTRUCTOR');
    _requestSubscription = _requestBloc.listen((state) {
      if (state is RequestsLoaded) {
        add(UpdateBadgeCount(numRequests: state.requestList.length));
      }
    });
  }

  @override
  HomeNavigationBarState get initialState =>
      HomeNavigationBarLoaded(numRequests: 0);

  @override
  Stream<HomeNavigationBarState> mapEventToState(
      HomeNavigationBarEvent event) async* {
    if (event is LoadBadgeCounts) {
      yield* _mapLoadBadgeCountsToState();
    } else if (event is UpdateBadgeCount) {
      yield* _mapUpdateBadgeCountToState(event);
    } else if (event is ClearBadgeCounts) {
      yield* _mapClearBadgeCountsToState();
    }
  }

  Stream<HomeNavigationBarState> _mapLoadBadgeCountsToState() async* {}

  Stream<HomeNavigationBarState> _mapUpdateBadgeCountToState(
      UpdateBadgeCount event) async* {
    yield HomeNavigationBarLoaded(numRequests: event.numRequests);
  }

  Stream<HomeNavigationBarState> _mapClearBadgeCountsToState() async* {
    yield HomeNavigationBarLoaded(numRequests: 0);
  }
}
