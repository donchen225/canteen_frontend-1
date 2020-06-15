import 'package:canteen_frontend/models/post/post.dart';
import 'package:equatable/equatable.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostsLoading extends PostState {}

class PostsLoaded extends PostState {
  final String groupId;
  final List<DetailedPost> posts;

  const PostsLoaded({this.groupId, this.posts});

  @override
  List<Object> get props => [
        groupId,
        posts,
      ];

  @override
  String toString() => 'PostsLoaded';
}

class PostsPrivate extends PostState {}

class PostsEmpty extends PostState {}
