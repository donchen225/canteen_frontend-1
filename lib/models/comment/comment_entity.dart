import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class CommentEntity extends Equatable {
  final String id;
  final String from;
  final String message;
  final DateTime lastUpdated;
  final DateTime createdOn;

  const CommentEntity(
      {@required this.id,
      @required this.from,
      @required this.message,
      @required this.lastUpdated,
      @required this.createdOn});

  Map<String, Object> toJson() {
    return {
      'id': id,
      'from': from,
      'message': message,
      'last_updated': lastUpdated,
      'created_on': createdOn,
    };
  }

  @override
  List<Object> get props => [id, from, message, lastUpdated, createdOn];

  @override
  String toString() {
    return 'CommentEntity { id: $id, from: $from, message: $message, createdOn: $createdOn, lastUpdated $lastUpdated }';
  }

  static CommentEntity fromJson(Map<String, Object> json) {
    return CommentEntity(
      id: json['id'] as String,
      from: json['from'] as String,
      message: json['message'] as String,
      createdOn: DateTime.parse(json['created_on']),
      lastUpdated: DateTime.parse(json['last_updated']),
    );
  }

  static CommentEntity fromSnapshot(DocumentSnapshot snapshot) {
    return CommentEntity(
      id: snapshot.documentID,
      from: snapshot.data['from'],
      message: snapshot.data['message'],
      createdOn: snapshot.data["created_on"].toDate(),
      lastUpdated: snapshot.data['last_updated'].toDate(),
    );
  }

  Map<String, Object> toDocument() {
    return {
      'id': id,
      'from': from,
      'message': message,
      'created_on': createdOn,
      'last_updated': lastUpdated,
    };
  }
}
