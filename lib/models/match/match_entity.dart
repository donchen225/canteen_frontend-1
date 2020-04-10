import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class MatchEntity extends Equatable {
  final String id;
  final Map<String, int> userId;
  final String chatId;
  final int status;
  final DateTime createdOn;

  const MatchEntity(
      {@required this.id,
      @required this.userId,
      @required this.chatId,
      @required this.status,
      @required this.createdOn});

  Map<String, Object> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'chat_id': chatId,
      'status': status,
      'created_on': createdOn,
    };
  }

  @override
  List<Object> get props => [id, userId, chatId, status, createdOn];

  @override
  String toString() {
    return 'MatchEntity { id: $id, userId: $userId, chatId: $chatId, status: $status, createdOn: $createdOn }';
  }

  static MatchEntity fromJson(Map<String, Object> json) {
    return MatchEntity(
      id: json['id'] as String,
      userId: json['user_id'] as Map<String, int>,
      chatId: json['chat_id'] as String,
      status: json['status'] as int,
      createdOn: DateTime.parse(json['created_on']),
    );
  }

  static MatchEntity fromSnapshot(DocumentSnapshot snapshot) {
    return MatchEntity(
        id: snapshot.documentID,
        userId: snapshot.data['user_id']
            .map<String, int>((k, v) => MapEntry(k as String, v as int)),
        chatId: snapshot.data['chat_id'],
        status: snapshot.data['status'],
        createdOn: snapshot.data["created_on"].toDate());
  }

  Map<String, Object> toDocument() {
    return {
      'user_id': userId,
      'chat_id': chatId,
      'status': status,
      'created_on': createdOn,
    };
  }
}
