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
  final List<Post> posts;
  final User user;

  const PostsLoaded({this.posts = const [], this.user});

  @override
  List<Object> get props => [posts, user];

  @override
  String toString() =>
      'PostsLoaded { posts: $posts user: ${user.displayName} }';
}

class PostsEmpty extends PostState {}
