import 'package:canteen_frontend/models/comment/comment.dart';
import 'package:equatable/equatable.dart';

abstract class CommentListState extends Equatable {
  const CommentListState();

  @override
  List<Object> get props => [];
}

class CommentListUninitialized extends CommentListState {}

class CommentListLoading extends CommentListState {
  @override
  String toString() {
    return 'CommentListLoading';
  }
}

class CommentListLoaded extends CommentListState {
  final List<DetailedComment> commentList;

  const CommentListLoaded({this.commentList});

  @override
  List<Object> get props => [commentList];

  @override
  String toString() {
    return 'CommentListLoaded';
  }
}

class CommentListUnauthenticated extends CommentListState {}
