import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class MatchEntity extends Equatable {
  final String id;
  final Map<String, int> userId;
  final List<String> messageId;
  final int status;

  const MatchEntity(
      {@required this.id,
      @required this.userId,
      @required this.messageId,
      @required this.status});

  Map<String, Object> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'message_id': messageId,
      'status': status,
    };
  }

  @override
  List<Object> get props => [id, userId, messageId, status];

  @override
  String toString() {
    return 'MatchEntity { id: $id, userId: $userId, messageId: $messageId, status: $status }';
  }

  static MatchEntity fromJson(Map<String, Object> json) {
    return MatchEntity(
      id: json['id'] as String,
      userId: json['user_id'] as Map<String, int>,
      messageId: json['message_id'] as List<String>,
      status: json['status'] as int,
    );
  }

  static MatchEntity fromSnapshot(DocumentSnapshot snapshot) {
    return MatchEntity(
      id: snapshot.documentID,
      userId: snapshot.data['user_id']
          .map<String, int>((k, v) => MapEntry(k as String, v as int)),
      messageId: snapshot.data['message_id']
              ?.map<String>((item) => item.toString())
              ?.toList() ??
          [],
      status: snapshot.data['status'],
    );
  }

  Map<String, Object> toDocument() {
    return {
      'user_id': userId,
      'message_id': messageId,
      'status': status,
    };
  }
}
