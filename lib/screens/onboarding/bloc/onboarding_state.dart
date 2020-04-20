import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object> get props => [];
}

class WelcomeScreenLoaded extends OnboardingState {}

class OnboardingSignUpScreensLoaded extends OnboardingState {}

class OnboardingCompleteScreenLoaded extends OnboardingState {}
