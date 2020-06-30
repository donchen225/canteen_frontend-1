import 'package:canteen_frontend/models/group/group.dart';
import 'package:equatable/equatable.dart';

abstract class GroupHomeEvent extends Equatable {
  const GroupHomeEvent();

  @override
  List<Object> get props => [];
}

class LoadUserGroups extends GroupHomeEvent {}

class LoadHomeGroup extends GroupHomeEvent {
  final Group group;

  const LoadHomeGroup(this.group);

  @override
  List<Object> get props => [group];

  @override
  String toString() => 'LoadGroup { group: $group }';
}

class LoadHomeGroupMembers extends GroupHomeEvent {
  final String groupId;

  const LoadHomeGroupMembers(this.groupId);

  @override
  List<Object> get props => [groupId];

  @override
  String toString() => 'LoadHomeGroupMembers { groupId: $groupId }';
}

class LoadDefaultGroup extends GroupHomeEvent {
  @override
  String toString() => 'LoadDefaultGroup';
}
