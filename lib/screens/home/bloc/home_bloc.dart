import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/models/user_settings/user_settings.dart';
import 'package:canteen_frontend/screens/home/bloc/home_event.dart';
import 'package:canteen_frontend/screens/home/bloc/home_state.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final UserRepository _userRepository;
  int _previousIndex = 0;
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
    _previousIndex = currentIndex;
    currentIndex = event.index;
    yield CurrentIndexChanged(currentIndex: currentIndex);
    yield PageLoading();

    final reset = _previousIndex != currentIndex ? false : true;

    switch (this.currentIndex) {
      case 0:
        yield RecommendedScreenLoaded(reset: reset);
        break;
      case 1:
        yield SearchScreenLoaded(reset: reset);
        break;
      case 2:
        yield RequestScreenLoaded(reset: reset);
        break;
      case 3:
        yield MatchScreenLoaded(reset: reset);
        break;
      case 4:
        yield UserProfileScreenLoaded(reset: reset);
        break;
    }
  }

  Stream<HomeState> _mapCheckOnboardStatusToState() async* {
    final user = await _userRepository.currentUser();

    if (user.onBoarded != null && user.onBoarded == 1) {
      yield HomeInitializing();

      // Load user settings here else create settings
      UserSettings settings;
      try {
        settings = await _userRepository.getSettings();
        if (settings == null) {
          final currentTime = DateTime.now();
          settings = UserSettings(
              pushNotifications: true,
              timeZone: currentTime.timeZoneOffset.inSeconds,
              timeZoneName: currentTime.timeZoneName);

          _userRepository.createSettings(settings);
        }
      } catch (e) {
        print('ERROR GETTING SETTINGS: $e');
      }

      // Save settings in shared preferences
      CachedSharedPreferences.setBool(
          PreferenceConstants.pushNotifications, settings.pushNotifications);
      CachedSharedPreferences.setInt(
          PreferenceConstants.timeZone, settings.timeZone);
      CachedSharedPreferences.setString(
          PreferenceConstants.timeZoneName, settings.timeZoneName);

      yield RecommendedScreenLoaded();
    } else {
      yield OnboardScreenLoaded();
    }
  }

  Stream<HomeState> _mapInitializeHomeToState() async* {
    yield HomeInitializing();

    // Upload user settings here

    yield RecommendedScreenLoaded();
  }

  Stream<HomeState> _mapClearHomeToState() async* {
    _previousIndex = 0;
    currentIndex = 0;
    yield HomeUninitialized();
  }
}
