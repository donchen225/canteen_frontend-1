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
class EditTeachSkill extends UserProfileEvent {
  final User user;

  const EditTeachSkill(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'EditTeachSkill { user: ${user.toString()} }';
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

class UpdateTeachSkill extends UserProfileEvent {
  final User user;
  final Skill skill;

  const UpdateTeachSkill(this.user, this.skill);

  @override
  List<Object> get props => [user];

  @override
  String toString() =>
      'UpdateTeachSkill { user: ${user.toString()} skill: ${skill.toString()} }';
}
