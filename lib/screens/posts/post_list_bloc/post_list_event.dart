import 'package:canteen_frontend/models/post/post.dart';
import 'package:equatable/equatable.dart';

abstract class PostListEvent extends Equatable {
  const PostListEvent();

  @override
  List<Object> get props => [];
}

class LoadPostList extends PostListEvent {
  final String groupId;
  final List<Post> posts;

  LoadPostList({this.groupId, this.posts});

  @override
  List<Object> get props => [groupId, posts];

  @override
  String toString() => 'LoadPostList';
}
