import 'package:canteen_frontend/models/comment/comment_entity.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Comment extends Equatable {
  final String id;
  final String from;
  final String message;
  final DateTime lastUpdated;
  final DateTime createdOn;

  const Comment(
      {this.id,
      @required this.from,
      @required this.message,
      @required this.lastUpdated,
      @required this.createdOn});

  @override
  List<Object> get props => [
        id,
        from,
        message,
        lastUpdated,
        createdOn,
      ];

  @override
  String toString() {
    return 'Comment { id: $id, from: $from, message: $message, createdOn: $createdOn, lastUpdated $lastUpdated }';
  }

  static Comment fromEntity(CommentEntity entity) {
    return Comment(
      id: entity.id,
      from: entity.from,
      message: entity.message,
      createdOn: entity.createdOn,
      lastUpdated: entity.lastUpdated,
    );
  }

  CommentEntity toEntity() {
    return CommentEntity(
      id: id,
      from: from,
      message: message,
      lastUpdated: lastUpdated,
      createdOn: createdOn,
    );
  }
}

class DetailedComment extends Comment {
  final User user;

  DetailedComment({
    @required id,
    @required from,
    @required message,
    @required createdOn,
    @required lastUpdated,
    @required this.user,
  }) : super(
            id: id,
            from: from,
            message: message,
            lastUpdated: lastUpdated,
            createdOn: createdOn);

  static DetailedComment fromComment(
    Comment comment,
    User user,
  ) {
    return DetailedComment(
      id: comment.id,
      from: comment.from,
      message: comment.message,
      createdOn: comment.createdOn,
      lastUpdated: comment.lastUpdated,
      user: user,
    );
  }
}
