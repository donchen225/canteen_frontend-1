import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class RequestEntity extends Equatable {
  final String id;
  final String senderId;
  final String receiverId;
  final String referralId;
  final String skill;
  final double price;
  final int duration;
  final String comment;
  final String referralComment;
  final String type;
  final DateTime time;
  final int status;
  final DateTime createdOn;

  const RequestEntity(
      {@required this.id,
      @required this.senderId,
      @required this.receiverId,
      @required this.referralId,
      @required this.skill,
      @required this.price,
      @required this.duration,
      @required this.comment,
      @required this.referralComment,
      @required this.time,
      @required this.type,
      @required this.status,
      @required this.createdOn});

  @override
  List<Object> get props => [
        id,
        senderId,
        receiverId,
        referralId,
        skill,
        price,
        duration,
        comment,
        referralComment,
        time,
        type,
        status
      ];

  @override
  String toString() {
    return 'RequestEntity { id: $id, senderId: $senderId, receiverId: $receiverId, referralId: $referralId, skill: $skill, price: $price, duration: $duration, comment: $comment, referralComment: $referralComment, time: $time, type: $type, status: $status, createdOn: $createdOn }';
  }

  static RequestEntity fromSnapshot(DocumentSnapshot snapshot) {
    return RequestEntity(
      id: snapshot.documentID,
      senderId: snapshot.data['sender_id'],
      receiverId: snapshot.data['receiver_id'],
      referralId: snapshot.data['referral_id'],
      skill: snapshot.data['skill'],
      comment: snapshot.data['comment'],
      referralComment: snapshot.data['referral_comment'],
      price: snapshot.data['price']?.toDouble() ?? 0,
      duration: snapshot.data['duration'],
      type: snapshot.data['type'],
      time: snapshot.data['time']?.toDate() ?? null,
      status: snapshot.data['status'],
      createdOn: snapshot.data['created_on'].toDate(),
    );
  }
}
