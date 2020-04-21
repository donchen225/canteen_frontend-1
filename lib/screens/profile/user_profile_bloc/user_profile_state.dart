import 'package:canteen_frontend/models/skill/skill_type.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:equatable/equatable.dart';

abstract class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object> get props => [];
}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final User user;

  const UserProfileLoaded(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'UserProfileLoaded { user: ${user.toString()}  }';
}

class UserProfileEmpty extends UserProfileState {}

class UserProfileEditingAbout extends UserProfileState {
  final User user;

  const UserProfileEditingAbout(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'UserProfileEditingAbout { user: ${user.toString()}  }';
}

class UserProfileEditingSkill extends UserProfileState {
  final User user;
  final SkillType skillType;
  final int skillIndex;

  const UserProfileEditingSkill(this.user, this.skillType, this.skillIndex);

  @override
  List<Object> get props => [user, skillIndex];

  @override
  String toString() =>
      'UserProfileEditingSkill { user: ${user.toString()} skillType: $skillType skillIndex: $skillIndex  }';
}

class UserProfileEditingName extends UserProfileState {
  final User user;

  const UserProfileEditingName(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'UserProfileEditingName { user: ${user.toString()}  }';
}

class SettingsMenu extends UserProfileState {}
