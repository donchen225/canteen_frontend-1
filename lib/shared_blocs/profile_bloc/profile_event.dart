import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/models/user_settings/user_settings.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfile extends ProfileEvent {
  final String userId;

  const LoadProfile(this.userId);

  @override
  List<Object> get props => [userId];

  @override
  String toString() => 'LoadProfile { userId: $userId }';
}
