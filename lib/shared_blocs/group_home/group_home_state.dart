import 'package:canteen_frontend/models/group/group.dart';
import 'package:equatable/equatable.dart';

abstract class GroupHomeState extends Equatable {
  const GroupHomeState();

  @override
  List<Object> get props => [];
}

class GroupHomeUninitialized extends GroupHomeState {}

class GroupHomeLoaded extends GroupHomeState {
  final Group group;

  GroupHomeLoaded({this.group});

  @override
  List<Object> get props => [group];

  @override
  String toString() => 'GroupLoaded';
}

class GroupHomeLoading extends GroupHomeState {}

class GroupHomeEmpty extends GroupHomeState {}
