import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class RequestEntity extends Equatable {
  final String id;
  final String senderId;
  final String receiverId;
  final String skill;
  final double price;
  final int duration;
  final String comment;
  final DateTime time;
  final int status;
  final DateTime createdOn;

  const RequestEntity(
      {@required this.id,
      @required this.senderId,
      @required this.receiverId,
      @required this.skill,
      @required this.price,
      @required this.duration,
      @required this.comment,
      @required this.time,
      @required this.status,
      @required this.createdOn});

  Map<String, Object> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'skill': skill,
      'price': price,
      'duration': duration,
      'comment': comment,
      'time': time,
      'status': status,
      'created_on': createdOn,
    };
  }

  @override
  List<Object> get props =>
      [id, senderId, receiverId, skill, price, duration, comment, time, status];

  @override
  String toString() {
    return 'RequestEntity { id: $id, senderId: $senderId, receiverId: $receiverId, skill: $skill, price: $price, duration: $duration, comment: $comment, time: $time, status: $status, createdOn: $createdOn }';
  }

  static RequestEntity fromJson(Map<String, Object> json) {
    return RequestEntity(
      id: json['id'] as String,
      senderId: json['sender_id'] as String,
      receiverId: json['receiver_id'] as String,
      skill: json['skill'] as String,
      price: json['price'] as double,
      duration: json['duration'] as int,
      comment: json['comment'] as String,
      time: DateTime.parse(json['time']),
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
      price: snapshot.data['price'].toDouble(),
      duration: snapshot.data['duration'],
      time: snapshot.data['time']?.toDate() ?? null,
      status: snapshot.data['status'],
      createdOn: snapshot.data['created_on'].toDate(),
    );
  }

  Map<String, Object> toDocument() {
    return {
      'receiver_id': receiverId,
      'skill': skill,
      'price': price,
      'duration': duration,
      'comment': comment,
      'time': time.millisecondsSinceEpoch,
    };
  }
}
