import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:equatable/equatable.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostsLoading extends PostState {}

class PostsLoaded extends PostState {
  final List<DetailedPost> posts;

  const PostsLoaded({this.posts = const []});

  @override
  List<Object> get props => [posts];

  @override
  String toString() => 'PostsLoaded { posts: $posts }';
}

class PostsEmpty extends PostState {}
