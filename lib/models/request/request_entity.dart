import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class RequestEntity extends Equatable {
  final String id;
  final String senderId;
  final String receiverId;
  final String skill;
  final String comment;
  final int status;
  final DateTime createdOn;

  const RequestEntity(
      {@required this.id,
      @required this.senderId,
      @required this.receiverId,
      @required this.skill,
      @required this.comment,
      @required this.status,
      @required this.createdOn});

  Map<String, Object> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'skill': skill,
      'comment': comment,
      'status': status,
      'created_on': createdOn,
    };
  }

  @override
  List<Object> get props => [id, senderId, receiverId, skill, comment, status];

  @override
  String toString() {
    return 'RequestEntity { id: $id, senderId: $senderId, receiverId: $receiverId, skill: $skill, comment: $comment, status: $status, createdOn: $createdOn }';
  }

  static RequestEntity fromJson(Map<String, Object> json) {
    return RequestEntity(
      id: json['id'] as String,
      senderId: json['sender_id'] as String,
      receiverId: json['receiver_id'] as String,
      skill: json['skill'] as String,
      comment: json['comment'] as String,
      status: json['status'] as int,
      createdOn: DateTime.parse(json['created_on']),
    );
  }

  static RequestEntity fromSnapshot(DocumentSnapshot snapshot) {
    return RequestEntity(
      id: snapshot.documentID,
      senderId: snapshot.data['sender_id'],
      receiverId: snapshot.data['receiver_id'],
      skill: snapshot.data['skill'],
      comment: snapshot.data['comment'],
      status: snapshot.data['status'],
      createdOn: snapshot.data['created_on'].toDate(),
    );
  }

  Map<String, Object> toDocument() {
    return {
      'receiver_id': receiverId,
      'skill': skill,
      'comment': comment,
    };
  }
}
