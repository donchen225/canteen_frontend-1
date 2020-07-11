import 'package:canteen_frontend/models/comment/comment.dart';
import 'package:equatable/equatable.dart';

abstract class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object> get props => [];
}

class CommentsLoading extends CommentState {}

class CommentsLoaded extends CommentState {
  final List<DetailedComment> comments;
  final String postId;

  const CommentsLoaded({this.comments = const [], this.postId});

  CommentsLoaded copyWith({
    List<Comment> comments,
    String postId,
  }) {
    return CommentsLoaded(
        comments: comments ?? this.comments, postId: postId ?? this.postId);
  }

  @override
  List<Object> get props => [comments, postId];

  @override
  String toString() => 'CommentsLoaded';
}

class CommentsEmpty extends CommentState {}
