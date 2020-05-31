import 'package:canteen_frontend/models/group/group.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:equatable/equatable.dart';

abstract class DiscoverState extends Equatable {
  const DiscoverState();

  @override
  List<Object> get props => [];
}

class DiscoverUninitialized extends DiscoverState {
  @override
  String toString() => 'DiscoverUninitialized';
}

class DiscoverLoading extends DiscoverState {}

class DiscoverLoaded extends DiscoverState {
  final List<User> users;
  final List<User> recommendations;
  final List<Group> groups;

  const DiscoverLoaded({this.users, this.recommendations, this.groups});

  @override
  List<Object> get props => [users, recommendations, groups];

  @override
  String toString() => 'DiscoverLoaded';
}
