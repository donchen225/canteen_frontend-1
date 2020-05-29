import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/home/bloc/home_event.dart';
import 'package:canteen_frontend/screens/home/bloc/home_state.dart';
import 'package:canteen_frontend/shared_blocs/settings/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final UserRepository _userRepository;
  final SettingBloc _settingBloc;
  int _previousIndex = 0;
  int currentIndex = 0;

  HomeBloc(
      {@required UserRepository userRepository,
      @required SettingBloc settingBloc})
      : assert(userRepository != null),
        assert(settingBloc != null),
        _userRepository = userRepository,
        _settingBloc = settingBloc;

  @override
  HomeState get initialState => HomeUninitialized();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is CheckOnboardStatus) {
      yield* _mapCheckOnboardStatusToState();
    } else if (event is InitializeHome) {
      yield* _mapInitializeHomeToState();
    } else if (event is ClearHome) {
      yield* _mapClearHomeToState();
    }
  }

  Stream<HomeState> _mapCheckOnboardStatusToState() async* {
    final user = await _userRepository.currentUser();

    if (user.onBoarded != null && user.onBoarded == 1) {
      yield HomeInitializing();

      // Load user settings
      _settingBloc.add(InitializeSettings(hasOnboarded: true));

      yield PostScreenLoaded(reset: false);
      // yield RecommendedScreenLoaded();
    } else {
      yield OnboardScreenLoaded();
    }
  }

  Stream<HomeState> _mapInitializeHomeToState() async* {
    yield HomeInitializing();

    // Upload user settings here

    yield PostScreenLoaded(reset: false);
  }

  Stream<HomeState> _mapClearHomeToState() async* {
    _previousIndex = 0;
    currentIndex = 0;
    yield HomeUninitialized();
  }
}
