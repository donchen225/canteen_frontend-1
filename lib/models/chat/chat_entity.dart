import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ChatEntity extends Equatable {
  final String id;
  final List<String> userId;
  final DateTime lastUpdated;
  final DateTime createdOn;

  const ChatEntity(
      {@required this.id,
      @required this.userId,
      @required this.lastUpdated,
      @required this.createdOn});

  @override
  List<Object> get props => [id, userId, lastUpdated, createdOn];

  @override
  String toString() {
    return 'ChatEntity { id: $id, userId: $userId, lastUpdated: $lastUpdated, createdOn: $createdOn }';
  }

  factory ChatEntity.fromSnapshot(DocumentSnapshot snapshot) {
    return ChatEntity(
      id: snapshot.documentID,
      userId: snapshot.data['user_id'].map<String>((x) => x as String).toList(),
      lastUpdated: snapshot.data['last_updated'].toDate(),
      createdOn: snapshot.data['created_on'].toDate(),
    );
  }

  Map<String, Object> toDocument() {
    return {
      'user_id': userId,
      'last_updated': lastUpdated,
      'created_on': createdOn,
    };
  }
}
