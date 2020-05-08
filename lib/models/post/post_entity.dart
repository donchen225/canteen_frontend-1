import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class PostEntity extends Equatable {
  final String id;
  final String from;
  final String title;
  final String message;
  final List<String> tags;
  final DateTime lastUpdated;
  final DateTime createdOn;

  const PostEntity(
      {@required this.id,
      @required this.from,
      @required this.title,
      @required this.message,
      @required this.tags,
      @required this.lastUpdated,
      @required this.createdOn});

  Map<String, Object> toJson() {
    return {
      'id': id,
      'from': from,
      'title': title,
      'message': message,
      'tags': tags,
      'last_updated': lastUpdated,
      'created_on': createdOn,
    };
  }

  @override
  List<Object> get props =>
      [id, from, title, message, tags, lastUpdated, createdOn];

  @override
  String toString() {
    return 'MatchEntity { id: $id, from: $from, title: $title, message: $message, tags: $tags, createdOn: $createdOn, lastUpdated $lastUpdated }';
  }

  static PostEntity fromJson(Map<String, Object> json) {
    return PostEntity(
      id: json['id'] as String,
      from: json['from'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      tags: json['tags'] as List<String>,
      createdOn: DateTime.parse(json['created_on']),
      lastUpdated: DateTime.parse(json['last_updated']),
    );
  }

  static PostEntity fromSnapshot(DocumentSnapshot snapshot) {
    return PostEntity(
      id: snapshot.documentID,
      from: snapshot.data['from'],
      title: snapshot.data['title'],
      message: snapshot.data['message'],
      tags: snapshot.data['tags']?.map<String>((x) => x as String)?.toList() ??
          [],
      createdOn: snapshot.data["created_on"].toDate(),
      lastUpdated: snapshot.data['last_updated'].toDate(),
    );
  }

  Map<String, Object> toDocument() {
    return {
      'id': id,
      'from': from,
      'title': title,
      'message': message,
      'tags': tags,
      'created_on': createdOn,
      'last_updated': lastUpdated,
    };
  }
}
