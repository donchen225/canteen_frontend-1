import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/onboarding/bloc/onboarding_event.dart';
import 'package:canteen_frontend/screens/onboarding/bloc/onboarding_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final UserRepository _userRepository;
  OnboardingBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  OnboardingState get initialState => WelcomeScreenLoaded();

  @override
  Stream<OnboardingState> mapEventToState(OnboardingEvent event) async* {
    if (event is LoadWelcomeScreen) {
      yield* _mapLoadWelcomeScreenToState();
    } else if (event is LoadOnboardingScreen) {
      yield* _mapLoadOnboardingScreenToState();
    }
  }

  Stream<OnboardingState> _mapLoadWelcomeScreenToState() async* {
    yield WelcomeScreenLoaded();
  }

  Stream<OnboardingState> _mapLoadOnboardingScreenToState() async* {
    final user = await _userRepository.currentUser();
    yield OnboardingSignUpScreensLoaded(user);
  }
}
