import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class MessageEntity extends Equatable {
  final String id;
  final String senderId;
  final DateTime timestamp;

  const MessageEntity(
      {@required this.id, @required this.senderId, @required this.timestamp});

  @override
  List<Object> get props => [id, senderId, timestamp];

  @override
  String toString() {
    return 'MessageEntity { id: $id, senderId: $senderId, timestamp: $timestamp }';
  }

  Map<String, Object> toDocument() {
    return {
      'sender_id': senderId,
      'timestamp': timestamp,
    };
  }
}
