import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class RequestEntity extends Equatable {
  final String id;
  final String sender;
  final String receiver;
  final String skill;
  final String comment;
  final int status;

  const RequestEntity(
      {@required this.id,
      @required this.sender,
      @required this.receiver,
      @required this.skill,
      @required this.comment,
      @required this.status});

  Map<String, Object> toJson() {
    return {
      'id': id,
      'sender': sender,
      'receiver': receiver,
      'skill': skill,
      'comment': comment,
      'status': status,
    };
  }

  @override
  List<Object> get props => [id, sender, receiver, skill, comment, status];

  @override
  String toString() {
    return 'MatchEntity { id: $id, sender: $sender, receiver: $receiver, skill: $skill, comment: $comment, status: $status }';
  }

  static RequestEntity fromJson(Map<String, Object> json) {
    return RequestEntity(
      id: json['id'] as String,
      sender: json['sender'] as String,
      receiver: json['receiver'] as String,
      skill: json['skill'] as String,
      comment: json['comment'] as String,
      status: json['status'] as int,
    );
  }

  static RequestEntity fromSnapshot(DocumentSnapshot snapshot) {
    return RequestEntity(
      id: snapshot.documentID,
      sender: snapshot.data['sender'],
      receiver: snapshot.data['receiver'],
      skill: snapshot.data['skill'],
      comment: snapshot.data['comment'],
      status: snapshot.data['status'],
    );
  }

  Map<String, Object> toDocument() {
    return {
      'sender': sender,
      'receiver': receiver,
      'skill': skill,
      'comment': comment,
      'status': status,
    };
  }
}
