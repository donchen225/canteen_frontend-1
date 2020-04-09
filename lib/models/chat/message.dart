import 'package:canteen_frontend/models/chat/message_entity.dart';
import 'package:canteen_frontend/models/chat/message_type.dart';
import 'package:meta/meta.dart';

@immutable
class Message {
  final String id;
  final String senderId;
  final MessageType type;
  final DateTime timestamp;

  Message({
    @required this.id,
    @required this.senderId,
    @required this.type,
    @required this.timestamp,
  });

  static Message fromEntity(MessageEntity entity) {
    return Message(
      id: entity.id,
      senderId: entity.senderId,
      type: MessageType.values[entity.type],
      timestamp: entity.timestamp,
    );
  }

  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      senderId: senderId,
      type: type.index,
      timestamp: timestamp,
    );
  }
}
