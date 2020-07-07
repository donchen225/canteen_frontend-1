import 'package:canteen_frontend/models/comment/comment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:tuple/tuple.dart';
import 'package:meta/meta.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object> get props => [];
}

class LoadComments extends CommentEvent {
  final String groupId;
  final String postId;

  const LoadComments({@required this.groupId, @required this.postId});

  @override
  String toString() => 'LoadComments';
}

class AddComment extends CommentEvent {
  final String groupId;
  final String postId;
  final Comment comment;

  const AddComment(
      {@required this.groupId, @required this.postId, @required this.comment});

  @override
  List<Object> get props => [groupId, postId, comment];

  @override
  String toString() =>
      'AddComment { groupId: $groupId, postId: $postId comment: $comment }';
}

class UpdateComment extends CommentEvent {
  final Comment comment;

  const UpdateComment(this.comment);

  @override
  List<Object> get props => [comment];

  @override
  String toString() => 'UpdateComment { comment: $comment }';
}

class DeleteComment extends CommentEvent {
  final Comment comment;

  const DeleteComment(this.comment);

  @override
  List<Object> get props => [comment];

  @override
  String toString() => 'DeleteComment { comment: $comment }';
}

class CommentsUpdated extends CommentEvent {
  final String postId;
  final List<Tuple2<DocumentChangeType, Comment>> updates;

  const CommentsUpdated(this.postId, this.updates);

  @override
  List<Object> get props => [postId, updates];

  @override
  String toString() => 'CommentsUpdated { postId: $postId}';
}

class ClearComments extends CommentEvent {}
