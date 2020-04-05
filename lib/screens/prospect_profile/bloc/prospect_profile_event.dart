import 'package:canteen_frontend/models/user/user.dart';
import 'package:equatable/equatable.dart';

abstract class ProspectProfileEvent extends Equatable {
  const ProspectProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProspectProfile extends ProspectProfileEvent {
  final User user;

  const LoadProspectProfile(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'LoadProspectProfile { user: ${user.toString()} }';
}
