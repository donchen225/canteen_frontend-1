import 'package:canteen_frontend/models/availability/day.dart';
import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/models/skill/skill_type.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:equatable/equatable.dart';

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

class ShowUserProfile extends UserProfileEvent {
  const ShowUserProfile();

  @override
  List<Object> get props => null;

  @override
  String toString() => 'ShowUserProfile';
}

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
  String toString() => 'UpdateName { title: $title }';
}

class EditAvailability extends UserProfileEvent {
  final User user;
  final Day day;

  const EditAvailability(this.user, this.day);

  @override
  List<Object> get props => [user, day];

  @override
  String toString() =>
      'EditAvailability { user: ${user.displayName} day: $day }';
}

class UpdateAvailability extends UserProfileEvent {
  final Day day;
  final DateTime startTime;
  final DateTime endTime;

  const UpdateAvailability(this.day, this.startTime, this.endTime);

  @override
  List<Object> get props => [day, startTime, endTime];

  @override
  String toString() =>
      'UpdateAvailability { day: $day, startTime: $startTime, endTime: $endTime }';
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

class ShowSettings extends UserProfileEvent {}
