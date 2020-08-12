import 'package:canteen_frontend/models/group/group.dart';
import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {
  @override
  List<Object> get props => null;
}

class OnboardingUninitialized extends OnboardingState {}

class OnboardingLoading extends OnboardingState {}

class OnboardingInProgress extends OnboardingState {
  final String name;
  final String photoUrl;
  final String about;
  final Skill skill;

  OnboardingInProgress(
      {this.name = '', this.photoUrl = '', this.about = '', this.skill});

  @override
  List<Object> get props => [name, photoUrl, about, skill];

  @override
  String toString() =>
      'OnboardingInProgress { name: $name, photoUrl: $photoUrl, about: $about, skill: $skill }';
}

class OnboardingGroups extends OnboardingState {
  final List<Group> groups;
  final List<bool> joined;

  OnboardingGroups({this.groups, this.joined});

  @override
  List<Object> get props => [groups, joined];

  @override
  String toString() => 'OnboardingGroups { groups: $groups, joined: $joined }';
}
