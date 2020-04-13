import 'package:canteen_frontend/models/skill/skill.dart';
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
  String toString() => 'LoadUserProfile { user: ${user.toString()} }';
}

class ClearProfile extends UserProfileEvent {}

class EditAboutSection extends UserProfileEvent {
  final User user;

  const EditAboutSection(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'EditAboutSection { user: ${user.toString()} }';
}

// TODO: remove User
class EditSkill extends UserProfileEvent {
  final User user;
  final int skillIndex;
  final String skillType;

  const EditSkill(this.user, this.skillType, this.skillIndex);

  @override
  List<Object> get props => [user, skillType, skillIndex];

  @override
  String toString() =>
      'EditSkill { user: ${user.toString()} skillType: $skillType skillIndex: $skillIndex }';
}

class UpdateAboutSection extends UserProfileEvent {
  final User user;
  final String about;

  const UpdateAboutSection(this.user, this.about);

  @override
  List<Object> get props => [user];

  @override
  String toString() =>
      'UpdateAboutSection { user: ${user.toString()} about: $about }';
}

class EditName extends UserProfileEvent {
  final User user;

  const EditName(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'EditName { user: ${user.toString()} }';
}

class UpdateName extends UserProfileEvent {
  final User user;
  final String name;

  const UpdateName(this.user, this.name);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'UpdateName { user: ${user.toString()} name: $name }';
}

class UpdateSkill extends UserProfileEvent {
  final User user;
  final Skill skill;
  final String skillType;
  final int skillIndex;

  const UpdateSkill(this.user, this.skill, this.skillType, this.skillIndex);

  @override
  List<Object> get props => [user, skill, skillType, skillIndex];

  @override
  String toString() =>
      'UpdateSkill { user: ${user.toString()} skill: ${skill.toString()} skillType: $skillType skillIndex: $skillIndex }';
}
