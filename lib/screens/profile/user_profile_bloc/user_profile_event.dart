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

class UpdateAboutSection extends UserProfileEvent {
  final User user;

  const UpdateAboutSection(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'UpdateAboutSection { user: ${user.toString()} }';
}
