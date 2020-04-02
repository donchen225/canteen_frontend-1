import 'package:canteen_frontend/models/user/user.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class InitializeUser extends UserEvent {
  final FirebaseUser firebaseUser;

  const InitializeUser(this.firebaseUser);

  @override
  List<Object> get props => [firebaseUser];

  @override
  String toString() => 'InitializeUser { firebaseUser: $firebaseUser }';
}

class LoadUser extends UserEvent {
  final User user;

  const LoadUser(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'LoadUser { user: $user }';
}

abstract class UpdateUser extends UserEvent {
  final String id;

  const UpdateUser(this.id);
}

class UpdateUserDisplayName extends UpdateUser {
  final String id;
  final String displayName;

  const UpdateUserDisplayName(this.id, this.displayName) : super(id);

  @override
  List<Object> get props => [id, displayName];

  @override
  String toString() =>
      'UpdateUserDisplayName { id: $id, displayName: $displayName }';
}

class LogOutUser extends UserEvent {}
