import 'package:canteen_frontend/models/group/group.dart';
import 'package:equatable/equatable.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object> get props => [];
}

class LoadUserGroups extends GroupEvent {}

class LoadCurrentGroup extends GroupEvent {}

class LoadGroup extends GroupEvent {
  final Group group;

  const LoadGroup(this.group);

  @override
  List<Object> get props => [group];

  @override
  String toString() => 'LoadGroup { group: $group }';
}
