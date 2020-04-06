import 'package:canteen_frontend/models/skill/skill.dart';
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

class ConfirmProspectProfile extends ProspectProfileEvent {
  final User user;

  const ConfirmProspectProfile(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'ConfirmProspectProfile { user: ${user.toString()} }';
}

class SendProspectRequest extends ProspectProfileEvent {
  final User user;
  final Skill skill;

  const SendProspectRequest(this.user, this.skill);

  @override
  List<Object> get props => [user, skill];

  @override
  String toString() =>
      'SendProspectRequest { user: ${user.toString()}, skill: ${skill.toString()} }';
}
