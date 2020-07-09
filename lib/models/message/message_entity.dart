import 'package:canteen_frontend/models/message/message_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class MessageEntity extends Equatable {
  final String id;
  final String senderId;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  MessageEntity({this.id, this.senderId, this.data, this.timestamp});

  @override
  List<Object> get props => [id, senderId, data, timestamp];

  @override
  String toString() {
    return 'MessageEntity { id: $id, senderId: $senderId, data: $data, timestamp: $timestamp }';
  }

  factory MessageEntity.fromSnapshot(DocumentSnapshot snapshot) {
    final int type = snapshot.data['type'];
    final int source = snapshot.data['source'];

    MessageEntity message;
    switch (source) {
      case 0:
        message = TextMessageEntity.fromSnapshot(snapshot);
        break;
      case 1:
        message = SystemMessageEntity.fromSnapshot(snapshot);
        break;
      default:
        message = TextMessageEntity.fromSnapshot(snapshot);
        break;
    }
    return message;
  }

  Map<String, Object> toDocument() {
    return {
      'sender_id': senderId,
      'data': data,
      'timestamp': timestamp,
    };
  }
}

class TextMessageEntity extends MessageEntity {
  final String text;

  TextMessageEntity({
    this.text,
    id,
    senderId,
    data,
    timestamp,
  }) : super(
          id: id,
          senderId: senderId,
          data: data,
          timestamp: timestamp,
        );

  factory TextMessageEntity.fromSnapshot(DocumentSnapshot snapshot) {
    Map data = snapshot.data;
    return TextMessageEntity(
      id: snapshot.documentID,
      text: data['text'],
      data: data['data'],
      senderId: data['sender_id'],
      timestamp: data['timestamp'].toDate(),
    );
  }

  @override
  String toString() =>
      '{ id : $id, senderId : $senderId, timeStamp : $timestamp, text: $text, data: $data, type: ${MessageType.text.index} } }';

  Map<String, Object> toDocument() {
    return {
      'text': text,
      'sender_id': senderId,
      'timestamp': timestamp,
      'data': data,
      'type': MessageType.text.index,
    };
  }
}

class SystemMessageEntity extends MessageEntity {
  final String text;
  final Map<String, dynamic> data;
  final String event;

  SystemMessageEntity({
    this.text,
    this.data,
    this.event,
    id,
    senderId,
    timestamp,
  }) : super(
          id: id,
          senderId: senderId,
          data: data,
          timestamp: timestamp,
        );

  factory SystemMessageEntity.fromSnapshot(DocumentSnapshot snapshot) {
    Map data = snapshot.data;

    final String event = data['event'];

    return SystemMessageEntity(
      id: snapshot.documentID,
      text: data['text'],
      data: data['data'],
      event: event,
      senderId: data['sender_id'],
      timestamp: data['timestamp'].toDate(),
    );
  }

  @override
  String toString() =>
      '{ id : $id, senderId : $senderId, timeStamp : $timestamp, text: $text, type: ${MessageType.text.index} } }';
}
