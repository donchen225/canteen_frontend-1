import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:equatable/equatable.dart';

class PostListState extends Equatable {
  final bool previous;

  const PostListState({this.previous = false});

  @override
  List<Object> get props => [];
}

class PostListUninitialized extends PostListState {}

class PostListLoaded extends PostListState {
  final List<DetailedPost> posts;
  final User user;
  final String groupId;

  const PostListLoaded({this.posts, this.user, this.groupId})
      : assert(posts != null),
        assert(user != null),
        assert(groupId != null);

  @override
  List<Object> get props => [posts, user, groupId];

  @override
  String toString() => 'PostListLoaded';
}

class PostListLoading extends PostListState {}
