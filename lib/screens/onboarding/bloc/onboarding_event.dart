import 'package:equatable/equatable.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object> get props => [];
}

class LoadWelcomeScreen extends OnboardingEvent {}

class LoadOnboardingScreen extends OnboardingEvent {}
