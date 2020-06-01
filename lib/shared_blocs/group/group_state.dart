import 'package:canteen_frontend/models/group/group.dart';
import 'package:equatable/equatable.dart';

abstract class GroupState extends Equatable {
  const GroupState();

  @override
  List<Object> get props => [];
}

class GroupUninitialized extends GroupState {}

class GroupLoaded extends GroupState {
  final Group group;

  GroupLoaded({this.group});

  @override
  List<Object> get props => [group];

  @override
  String toString() => 'GroupLoaded';
}

class GroupLoading extends GroupState {}
