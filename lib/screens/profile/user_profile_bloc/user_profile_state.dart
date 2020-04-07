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

class UserProfileEditingTeachSkill extends UserProfileState {
  final User user;
  final int skillIndex;

  const UserProfileEditingTeachSkill(this.user, this.skillIndex);

  @override
  List<Object> get props => [user, skillIndex];

  @override
  String toString() =>
      'UserProfileEditingTeachSkill { user: ${user.toString()}, skillIndex: $skillIndex  }';
}

class UserProfileEditingLearnSkill extends UserProfileState {
  final User user;

  const UserProfileEditingLearnSkill(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() =>
      'UserProfileEditingLearnSkill { user: ${user.toString()}  }';
}
