import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object> get props => [];
}

class LoadWelcomeScreen extends OnboardingEvent {}

class LoadOnboarding extends OnboardingEvent {}

class CompleteOnboarding extends OnboardingEvent {
  final String name;
  final Skill skill;

  const CompleteOnboarding({@required this.name, @required this.skill});

  @override
  List<Object> get props => [name, skill];

  @override
  String toString() => 'CompleteOnboarding { name: $name, skill: $skill }';
}
