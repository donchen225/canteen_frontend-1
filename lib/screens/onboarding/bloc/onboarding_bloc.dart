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
    } else if (event is LoadOnboarding) {
      yield* _mapLoadOnboardingToState();
    } else if (event is CompleteOnboarding) {
      yield* _mapCompleteOnboardingToState(event);
    }
  }

  Stream<OnboardingState> _mapLoadWelcomeScreenToState() async* {
    yield WelcomeScreenLoaded();
  }

  Stream<OnboardingState> _mapLoadOnboardingToState() async* {
    final user = await _userRepository.currentUser();
    yield OnboardingSignUpScreensLoaded(user);
  }

  Stream<OnboardingState> _mapCompleteOnboardingToState(
      CompleteOnboarding event) async* {
    print('UPDATED USER ONBOARDING');
    _userRepository.updateUserOnboarding(event.name, event.skill);
    yield OnboardingCompleteScreenLoaded();
  }
}
