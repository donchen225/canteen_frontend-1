import 'package:canteen_frontend/models/comment/comment.dart';
import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:equatable/equatable.dart';

abstract class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object> get props => [];
}

class CommentsLoading extends CommentState {}

class CommentsLoaded extends CommentState {
  final List<Comment> comments;

  const CommentsLoaded({this.comments = const []});

  @override
  List<Object> get props => [comments];

  @override
  String toString() => 'CommentsLoaded { comments: $comments }';
}

class CommentsEmpty extends CommentState {}
