import 'package:canteen_frontend/models/post/post.dart';
import 'package:equatable/equatable.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostsLoading extends PostState {
  final String groupId;
  final bool isHome;

  const PostsLoading({this.groupId, this.isHome});

  @override
  List<Object> get props => [groupId, isHome];

  @override
  String toString() => 'PostsLoading';
}

class PostsLoaded extends PostState {
  final String groupId;
  final List<DetailedPost> posts;

  const PostsLoaded({this.groupId, this.posts});

  @override
  List<Object> get props => [groupId, posts];

  @override
  String toString() => 'PostsLoaded';
}

class PostsPrivate extends PostState {
  final String groupId;
  final bool isHome;

  const PostsPrivate({this.groupId, this.isHome});

  @override
  List<Object> get props => [groupId, isHome];

  @override
  String toString() => 'PostsPrivate';
}

class PostsEmpty extends PostState {}
