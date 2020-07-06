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
  final String hash;

  const PostsLoaded({this.groupId, this.posts, this.hash = ''});

  @override
  List<Object> get props => [groupId, posts, hash];

  @override
  String toString() => 'PostsLoaded';
}

class PostsPrivate extends PostState {}

class PostsEmpty extends PostState {}
