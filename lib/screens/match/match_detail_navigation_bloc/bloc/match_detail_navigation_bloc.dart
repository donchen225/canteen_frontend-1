import 'package:canteen_frontend/screens/match/match_detail_navigation_bloc/bloc/match_detail_navigation_event.dart';
import 'package:canteen_frontend/screens/match/match_detail_navigation_bloc/bloc/match_detail_navigation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchDetailNavigationBloc
    extends Bloc<MatchDetailNavigationEvent, MatchDetailNavigationState> {
  int _previousIndex = 0;
  int currentIndex = 0;

  MatchDetailNavigationBloc();

  @override
  MatchDetailNavigationState get initialState => MatchNavigationUninitialized();

  @override
  Stream<MatchDetailNavigationState> mapEventToState(
      MatchDetailNavigationEvent event) async* {
    if (event is TabTapped) {
      yield* _mapPageTappedToState(event);
    } else if (event is ClearHome) {
      yield* _mapClearHomeToState();
    }
  }

  Stream<MatchDetailNavigationState> _mapPageTappedToState(
      TabTapped event) async* {
    _previousIndex = currentIndex;
    currentIndex = event.index;
    yield CurrentIndexChanged(currentIndex: currentIndex);

    switch (this.currentIndex) {
      case 0:
        yield ChatScreenLoaded();
        break;
      case 1:
        yield VideoChatDetailScreenLoaded();
        break;
      case 2:
        yield ProfileScreenLoaded();
        break;
    }
  }

  Stream<MatchDetailNavigationState> _mapClearHomeToState() async* {
    _previousIndex = 0;
    currentIndex = 0;
    yield MatchNavigationUninitialized();
  }
}
