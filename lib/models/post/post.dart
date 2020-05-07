import 'package:canteen_frontend/models/post/post_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Post extends Equatable {
  final String id;
  final String from;
  final String title;
  final String message;
  final List<String> tags;
  final DateTime lastUpdated;
  final DateTime createdOn;

  const Post(
      {@required this.id,
      @required this.from,
      @required this.title,
      @required this.message,
      @required this.tags,
      @required this.lastUpdated,
      @required this.createdOn});

  @override
  List<Object> get props => [
        id,
        from,
        title,
        message,
        tags,
        lastUpdated,
        createdOn,
      ];

  @override
  String toString() {
    return 'MatchEntity { id: $id, from: $from, title: $title, message: $message, tags: $tags, createdOn: $createdOn, lastUpdated $lastUpdated }';
  }

  static Post fromEntity(PostEntity entity) {
    return Post(
      id: entity.id,
      from: entity.from,
      title: entity.title,
      message: entity.message,
      tags: entity.tags,
      createdOn: entity.createdOn,
      lastUpdated: entity.lastUpdated,
    );
  }

  PostEntity toEntity() {
    return PostEntity(
      id: id,
      from: from,
      title: title,
      message: message,
      tags: tags,
      lastUpdated: lastUpdated,
      createdOn: createdOn,
    );
  }
}
