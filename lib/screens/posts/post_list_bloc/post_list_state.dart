import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:equatable/equatable.dart';

class PostListState extends Equatable {
  final bool previous;

  const PostListState({this.previous = false});

  @override
  List<Object> get props => [];
}

class PostListLoaded extends PostListState {
  final List<Post> posts;
  final User user;

  const PostListLoaded({this.posts, this.user})
      : assert(posts != null),
        assert(user != null);

  @override
  List<Object> get props => [posts, user];

  @override
  String toString() => 'PostListLoaded';
}

class PostListLoading extends PostListState {}
