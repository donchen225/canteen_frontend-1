import 'package:canteen_frontend/models/discover/popular_user.dart';
import 'package:canteen_frontend/models/group/group.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:equatable/equatable.dart';
import 'package:tuple/tuple.dart';

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
  final List<Tuple2<PopularUser, User>> popularUsers;
  final List<User> recommendations;
  final List<Group> groups;

  const DiscoverLoaded({
    this.popularUsers,
    this.recommendations,
    this.groups,
  });

  @override
  List<Object> get props => [popularUsers, recommendations, groups];

  @override
  String toString() => 'DiscoverLoaded';
}
