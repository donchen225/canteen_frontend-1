import 'package:canteen_frontend/models/group/group.dart';
import 'package:equatable/equatable.dart';

abstract class GroupHomeState extends Equatable {
  const GroupHomeState();

  @override
  List<Object> get props => [];
}

class GroupHomeUnauthenticated extends GroupHomeState {}

class GroupHomeLoaded extends GroupHomeState {
  final Group group;
  final DateTime lastUpdated;

  GroupHomeLoaded({this.group, this.lastUpdated});

  @override
  List<Object> get props => [group, lastUpdated];

  @override
  String toString() => 'GroupLoaded';
}

class GroupHomeLoading extends GroupHomeState {}

class GroupHomeEmpty extends GroupHomeState {}
