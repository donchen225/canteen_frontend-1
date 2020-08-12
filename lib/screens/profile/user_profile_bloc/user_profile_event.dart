import 'package:canteen_frontend/models/availability/day.dart';
import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/models/skill/skill_type.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadUserProfile extends UserProfileEvent {
  final User user;

  const LoadUserProfile(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'LoadUserProfile { user: ${user.displayName} }';
}

class ClearProfile extends UserProfileEvent {}

class EditAboutSection extends UserProfileEvent {
  final User user;

  const EditAboutSection(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'EditAboutSection';
}

// TODO: remove User
class EditSkill extends UserProfileEvent {
  final User user;
  final int skillIndex;
  final SkillType skillType;

  const EditSkill(this.user, this.skillType, this.skillIndex);

  @override
  List<Object> get props => [user, skillType, skillIndex];

  @override
  String toString() =>
      'EditSkill { user: ${user.displayName} skillType: $skillType skillIndex: $skillIndex }';
}

class UpdateAboutSection extends UserProfileEvent {
  final String about;

  const UpdateAboutSection(this.about);

  @override
  List<Object> get props => [about];

  @override
  String toString() => 'UpdateAboutSection { about: $about }';
}

class EditName extends UserProfileEvent {
  final User user;

  const EditName(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'EditName { user: ${user.displayName} }';
}

class UpdateName extends UserProfileEvent {
  final String name;

  const UpdateName(this.name);

  @override
  List<Object> get props => [name];

  @override
  String toString() => 'UpdateName { name: $name }';
}

class EditTitle extends UserProfileEvent {
  final User user;

  const EditTitle(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'EditTitle { user: ${user.displayName} }';
}

class UpdateTitle extends UserProfileEvent {
  final String title;

  const UpdateTitle(this.title);

  @override
  List<Object> get props => [title];

  @override
  String toString() => 'UpdateTitle { title: $title }';
}

class EditAvailability extends UserProfileEvent {
  final User user;
  final Day day;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  const EditAvailability({this.user, this.day, this.startTime, this.endTime});

  @override
  List<Object> get props => [user, day, startTime, endTime];

  @override
  String toString() =>
      'EditAvailability { user: ${user.displayName} day: $day startTime: $startTime endTime: $endTime }';
}

class UpdateAvailability extends UserProfileEvent {
  final Day day;
  final int startTimeSeconds;
  final int endTimeSeconds;

  const UpdateAvailability(
      this.day, this.startTimeSeconds, this.endTimeSeconds);

  @override
  List<Object> get props => [day, startTimeSeconds, endTimeSeconds];

  @override
  String toString() =>
      'UpdateAvailability { day: $day, startTime: $startTimeSeconds, endTime: $endTimeSeconds }';
}

class EditInterests extends UserProfileEvent {
  final User user;

  const EditInterests(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'EditInterests { user: ${user.displayName} }';
}

class UpdateInterests extends UserProfileEvent {
  final List<String> interests;

  const UpdateInterests(this.interests);

  @override
  List<Object> get props => [interests];

  @override
  String toString() => 'UpdateInterests { interests: $interests }';
}

class UpdateSkill extends UserProfileEvent {
  final User user;
  final Skill skill;
  final SkillType skillType;
  final int skillIndex;

  const UpdateSkill(this.user, this.skill, this.skillType, this.skillIndex);

  @override
  List<Object> get props => [user, skill, skillType, skillIndex];

  @override
  String toString() =>
      'UpdateSkill { user: ${user.toString()} skill: ${skill.toString()} skillType: $skillType skillIndex: $skillIndex }';
}

class DeleteSkill extends UserProfileEvent {
  final SkillType skillType;
  final int skillIndex;

  const DeleteSkill(this.skillType, this.skillIndex);

  @override
  List<Object> get props => [skillType, skillIndex];

  @override
  String toString() =>
      'DeleteSkill { skillType: $skillType skillIndex: $skillIndex }';
}

class ShowSettings extends UserProfileEvent {}
