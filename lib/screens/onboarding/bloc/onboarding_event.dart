import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object> get props => [];
}

class UpdateName extends OnboardingEvent {
  final String name;

  const UpdateName({@required this.name});

  @override
  List<Object> get props => [name];

  @override
  String toString() => 'UpdateName { name: $name }';
}

class UpdatePhoto extends OnboardingEvent {
  final File file;

  const UpdatePhoto({@required this.file});

  @override
  List<Object> get props => [file];

  @override
  String toString() => 'UpdatePhoto';
}

class UpdateAbout extends OnboardingEvent {
  final String about;

  const UpdateAbout({@required this.about});

  @override
  List<Object> get props => [about];

  @override
  String toString() => 'UpdateAbout { about: $about }';
}

class UpdateSkill extends OnboardingEvent {
  final String name;
  final int price;
  final int duration;
  final String description;
  final bool isOffering;

  const UpdateSkill(
      {@required this.name,
      @required this.price,
      @required this.duration,
      @required this.description,
      @required this.isOffering});

  @override
  List<Object> get props => [name, price, duration, description, isOffering];

  @override
  String toString() =>
      'UpdateSkill { name: $name, price: $price, duration: $duration, description: $description isOffering: $isOffering }';
}

class LoadGroups extends OnboardingEvent {}

class JoinPublicGroup extends OnboardingEvent {
  final String id;

  const JoinPublicGroup({@required this.id});

  @override
  List<Object> get props => [id];

  @override
  String toString() => 'JoinPublicGroup { id: $id }';
}

class JoinedPrivateGroup extends OnboardingEvent {
  final String id;

  const JoinedPrivateGroup({@required this.id});

  @override
  List<Object> get props => [id];

  @override
  String toString() => 'JoinedPrivateGroup { id: $id }';
}

class CompleteOnboarding extends OnboardingEvent {}
