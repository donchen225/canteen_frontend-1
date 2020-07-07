import 'package:canteen_frontend/models/comment/comment.dart';
import 'package:canteen_frontend/models/post/post.dart';
import 'package:equatable/equatable.dart';

abstract class CommentListEvent extends Equatable {
  const CommentListEvent();

  @override
  List<Object> get props => [];
}

class LoadCommentList extends CommentListEvent {
  final String postId;
  final String groupId;

  const LoadCommentList({this.postId, this.groupId});

  @override
  List<Object> get props => [postId, groupId];

  @override
  String toString() => 'LoadCommentList { postId: $postId, groupId: $groupId }';
}

class UpdateCommentList extends CommentListEvent {
  final List<DetailedComment> commentList;

  const UpdateCommentList({this.commentList});

  @override
  List<Object> get props => [commentList];

  @override
  String toString() => 'UpdateCommentList';
}

class LoadingPostList extends CommentListEvent {}

class ClearPostList extends CommentListEvent {}
