import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/models/user_settings/user_settings.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileUninitialized extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user;

  const ProfileLoaded(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'ProfileLoaded { ${user.displayName}  }';
}
