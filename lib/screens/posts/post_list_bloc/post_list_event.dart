import 'package:canteen_frontend/models/post/post.dart';
import 'package:equatable/equatable.dart';

abstract class PostListEvent extends Equatable {
  const PostListEvent();

  @override
  List<Object> get props => [];
}

class LoadPostList extends PostListEvent {
  final String groupId;
  final List<Post> postList;

  const LoadPostList({this.groupId, this.postList});

  @override
  List<Object> get props => [groupId, postList];

  @override
  String toString() =>
      'LoadPostList { grorupId: $groupId, postList: $postList }';
}

class LoadingPostList extends PostListEvent {}

class ClearPostList extends PostListEvent {}
