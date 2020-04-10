import 'package:canteen_frontend/models/chat/message_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class MessageEntity extends Equatable {
  final String id;
  final String senderId;
  final DateTime timestamp;

  MessageEntity(this.id, this.senderId, this.timestamp);

  @override
  List<Object> get props => [id, senderId, timestamp];

  @override
  String toString() {
    return 'MessageEntity { id: $id, senderId: $senderId, timestamp: $timestamp }';
  }

  factory MessageEntity.fromSnapshot(DocumentSnapshot snapshot) {
    final int type = snapshot.data['type'];
    MessageEntity message;
    switch (type) {
      case 0:
        message = TextMessageEntity.fromSnapshot(snapshot);
        break;
    }
    return message;
  }

  Map<String, Object> toDocument() {
    return {
      'sender_id': senderId,
      'timestamp': timestamp,
    };
  }
}

class TextMessageEntity extends MessageEntity {
  String text;

  TextMessageEntity({
    this.text,
    id,
    senderId,
    timestamp,
  }) : super(id, senderId, timestamp);

  factory TextMessageEntity.fromSnapshot(DocumentSnapshot snapshot) {
    Map data = snapshot.data;
    return TextMessageEntity(
      id: snapshot.documentID,
      text: data['text'],
      senderId: data['sender_id'],
      timestamp: data['timestamp'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'sender_id': senderId,
      'text': text,
      'timestamp': timestamp,
      'type': MessageType.text.index,
    };
  }

  @override
  String toString() =>
      '{ id : $id, senderId : $senderId, timeStamp : $timestamp, text: $text }';

  Map<String, Object> toDocument() {
    return {
      'text': text,
      'sender_id': senderId,
      'timestamp': timestamp,
    };
  }
}
