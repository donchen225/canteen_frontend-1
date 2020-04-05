import 'package:canteen_frontend/models/user/user.dart';
import 'package:equatable/equatable.dart';

abstract class ProspectProfileState extends Equatable {
  const ProspectProfileState();

  @override
  List<Object> get props => [];
}

class ProspectProfileLoading extends ProspectProfileState {}

class ProspectProfileLoaded extends ProspectProfileState {
  final User user;

  const ProspectProfileLoaded(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'UserProfileLoaded { ${user.toString()}  }';
}
