import 'package:canteen_frontend/models/group/group.dart';
import 'package:equatable/equatable.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object> get props => [];
}

class LoadGroup extends GroupEvent {
  final Group group;

  const LoadGroup(this.group);

  @override
  List<Object> get props => [group];

  @override
  String toString() => 'LoadGroup { group: $group }';
}

class JoinPublicGroup extends GroupEvent {
  final Group group;

  const JoinPublicGroup(this.group);

  @override
  List<Object> get props => [group];

  @override
  String toString() => 'JoinPublicGroup { group: $group }';
}

class JoinedPrivateGroup extends GroupEvent {
  final Group group;

  const JoinedPrivateGroup(this.group);

  @override
  List<Object> get props => [group];

  @override
  String toString() => 'JoinedPrivateGroup { group: $group }';
}

class LoadGroupMembers extends GroupEvent {
  final String groupId;

  const LoadGroupMembers(this.groupId);

  @override
  List<Object> get props => [groupId];

  @override
  String toString() => 'LoadGroupMembers { groupId: $groupId }';
}
