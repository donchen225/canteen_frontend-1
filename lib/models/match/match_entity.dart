import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class MatchEntity extends Equatable {
  final String id;
  final Map<String, int> userId;
  final List<String> quizId;
  final List<String> messageId;

  const MatchEntity(
      {@required this.id,
      @required this.userId,
      @required this.quizId,
      @required this.messageId});

  Map<String, Object> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'quiz_id': quizId,
      'message_id': messageId,
    };
  }

  @override
  List<Object> get props => [id, userId, quizId, messageId];

  @override
  String toString() {
    return 'MatchEntity { id: $id, userId: $userId, quizId: $quizId, messageId: $messageId }';
  }

  static MatchEntity fromJson(Map<String, Object> json) {
    return MatchEntity(
      id: json['id'] as String,
      userId: json['user_id'] as Map<String, int>,
      quizId: json['quiz_id'] as List<String>,
      messageId: json['message_id'] as List<String>,
    );
  }

  static MatchEntity fromSnapshot(DocumentSnapshot snapshot) {
    return MatchEntity(
      id: snapshot.documentID,
      userId: snapshot.data['user_id']
          .map<String, int>((k, v) => MapEntry(k as String, v as int)),
      quizId: snapshot.data['quiz_id']
              ?.map<String>((item) => item.toString())
              ?.toList() ??
          [],
      messageId: snapshot.data['message_id']
              ?.map<String>((item) => item.toString())
              ?.toList() ??
          [],
    );
  }

  Map<String, Object> toDocument() {
    return {
      'user_id': userId,
      'quiz_id': quizId,
      'message_id': messageId,
    };
  }
}
