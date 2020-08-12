import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class PostEntity extends Equatable {
  final String id;
  final String from;
  final String message;
  final List<String> tags;
  final int commentCount;
  final int likeCount;
  final DateTime lastUpdated;
  final DateTime createdOn;

  const PostEntity(
      {@required this.id,
      @required this.from,
      @required this.message,
      @required this.tags,
      @required this.commentCount,
      @required this.likeCount,
      @required this.lastUpdated,
      @required this.createdOn});

  Map<String, Object> toJson() {
    return {
      'id': id,
      'from': from,
      'message': message,
      'tags': tags,
      'comment_count': commentCount,
      'like_count': likeCount,
      'last_updated': lastUpdated,
      'created_on': createdOn,
    };
  }

  @override
  List<Object> get props => [
        id,
        from,
        message,
        tags,
        commentCount,
        likeCount,
        lastUpdated,
        createdOn
      ];

  @override
  String toString() {
    return 'PostEntity { id: $id, from: $from, message: $message, tags: $tags, commentCount: $commentCount, likeCount: $likeCount, createdOn: $createdOn, lastUpdated $lastUpdated }';
  }

  static PostEntity fromJson(Map<String, Object> json) {
    return PostEntity(
      id: json['id'] as String,
      from: json['from'] as String,
      message: json['message'] as String,
      tags: json['tags'] as List<String>,
      commentCount: json['comment_count'] as int,
      likeCount: json['like_count'] as int,
      createdOn: DateTime.parse(json['created_on']),
      lastUpdated: DateTime.parse(json['last_updated']),
    );
  }

  static PostEntity fromSnapshot(DocumentSnapshot snapshot) {
    return PostEntity(
      id: snapshot.documentID,
      from: snapshot.data['from'],
      message: snapshot.data['message'],
      tags: snapshot.data['tags']?.map<String>((x) => x as String)?.toList() ??
          [],
      commentCount: snapshot.data['comment_count'],
      likeCount: snapshot.data['like_count'],
      createdOn: snapshot.data["created_on"].toDate(),
      lastUpdated: snapshot.data['last_updated'].toDate(),
    );
  }

  Map<String, Object> toDocument() {
    return {
      'from': from,
      'message': message,
      'tags': tags,
      'comment_count': commentCount,
      'like_count': likeCount,
      'created_on': createdOn,
      'last_updated': lastUpdated,
    };
  }
}
