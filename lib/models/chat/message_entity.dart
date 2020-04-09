import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class MessageEntity extends Equatable {
  final String id;
  final String senderId;
  final int type;
  final DateTime timestamp;

  const MessageEntity(
      {@required this.id,
      @required this.senderId,
      @required this.type,
      @required this.timestamp});

  @override
  List<Object> get props => [id, senderId, type, timestamp];

  @override
  String toString() {
    return 'MessageEntity { id: $id, senderId: $senderId, type: $type, timestamp: $timestamp }';
  }

  Map<String, Object> toDocument() {
    return {
      'sender_id': senderId,
      'type': type,
      'timestamp': timestamp,
    };
  }
}
