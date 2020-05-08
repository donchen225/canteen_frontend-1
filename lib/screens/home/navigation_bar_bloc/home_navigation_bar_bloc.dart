import 'dart:async';

import 'package:canteen_frontend/screens/home/navigation_bar_bloc/home_navigation_bar_event.dart';
import 'package:canteen_frontend/screens/home/navigation_bar_bloc/home_navigation_bar_state.dart';
import 'package:canteen_frontend/screens/recommended/bloc/bloc.dart';
import 'package:canteen_frontend/screens/request/request_bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class HomeNavigationBarBloc
    extends Bloc<HomeNavigationBarEvent, HomeNavigationBarState> {
  final RequestBloc _requestBloc;
  final RecommendedBloc _recommendedBloc;
  StreamSubscription _requestSubscription;
  StreamSubscription _recommendedSubscription;

  HomeNavigationBarBloc(
      {@required RequestBloc requestBloc,
      @required RecommendedBloc recommendedBloc})
      : assert(requestBloc != null),
        assert(recommendedBloc != null),
        _requestBloc = requestBloc,
        _recommendedBloc = recommendedBloc {
    _requestSubscription = _requestBloc.listen((state) {
      if (state is RequestsLoaded) {
        add(UpdateBadgeCount(numRequests: state.requestList.length));
      }
    });

    _recommendedSubscription = _recommendedBloc.listen((state) {
      if (state is RecommendedLoaded) {
        add(UpdateBadgeCount(
            numRecommended: _recommendedBloc.recommendations.length -
                _recommendedBloc.currentIndex));
      } else if (state is RecommendedEmpty) {
        add(UpdateBadgeCount(numRecommended: 0));
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
    yield HomeNavigationBarLoaded(
      numRequests: event.numRequests,
      numRecommended: event.numRecommended,
    );
  }

  Stream<HomeNavigationBarState> _mapClearBadgeCountsToState() async* {
    yield HomeNavigationBarLoaded(
      numRequests: 0,
      numRecommended: 0,
    );
  }

  @override
  Future<void> close() {
    _requestSubscription?.cancel();
    _recommendedSubscription?.cancel();
    return super.close();
  }
}
