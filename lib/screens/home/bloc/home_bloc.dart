import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/home/bloc/home_event.dart';
import 'package:canteen_frontend/screens/home/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final UserRepository _userRepository;
  int currentIndex = 0;

  HomeBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  HomeState get initialState => HomeUninitialized();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is PageTapped) {
      yield* _mapPageTappedToState(event);
    } else if (event is CheckOnboardStatus) {
      yield* _mapCheckOnboardStatusToState();
    } else if (event is InitializeHome) {
      yield* _mapInitializeHomeToState();
    } else if (event is ClearHome) {
      yield* _mapClearHomeToState();
    }
  }

  Stream<HomeState> _mapPageTappedToState(PageTapped event) async* {
    currentIndex = event.index;
    yield CurrentIndexChanged(currentIndex: currentIndex);
    yield PageLoading();

    switch (this.currentIndex) {
      case 0:
        yield RecommendedScreenLoaded();
        break;
      case 1:
        yield SearchScreenLoaded();
        break;
      case 2:
        yield RequestScreenLoaded();
        break;
      case 3:
        yield MatchScreenLoaded();
        break;
      case 4:
        yield UserProfileScreenLoaded();
        break;
    }
  }

  Stream<HomeState> _mapCheckOnboardStatusToState() async* {
    final user = await _userRepository.currentUser();

    if (user.onBoarded != null && user.onBoarded == 1) {
      yield HomeInitializing();
      yield RecommendedScreenLoaded();
    } else {
      yield OnboardScreenLoaded();
    }
  }

  Stream<HomeState> _mapInitializeHomeToState() async* {
    yield HomeInitializing();
    yield RecommendedScreenLoaded();
  }

  Stream<HomeState> _mapClearHomeToState() async* {
    currentIndex = 0;
    yield HomeUninitialized();
  }
}
