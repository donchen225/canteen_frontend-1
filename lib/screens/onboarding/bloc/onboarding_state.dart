import 'package:canteen_frontend/models/user/user.dart';
import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object> get props => [];
}

class WelcomeScreenLoaded extends OnboardingState {}

class OnboardingSignUpScreensLoaded extends OnboardingState {
  final User user;

  const OnboardingSignUpScreensLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class OnboardingCompleteScreenLoaded extends OnboardingState {}
