import 'package:canteen_frontend/models/message/message_entity.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:meta/meta.dart';

@immutable
abstract class Message {
  final String id;
  final String senderId;
  final bool isSelf;
  final DateTime timestamp;

  Message({
    @required this.id,
    @required this.senderId,
    @required this.isSelf,
    @required this.timestamp,
  });

  factory Message.fromEntity(MessageEntity entity) {
    Message message;
    if (entity is TextMessageEntity) {
      message = TextMessage.fromEntity(entity);
    }
    return message;
  }

  MessageEntity toEntity() {}
}

@immutable
class TextMessage extends Message {
  final String id;
  final String senderId;
  final String text;
  final bool isSelf;
  final DateTime timestamp;

  TextMessage({
    this.id,
    @required this.senderId,
    @required this.text,
    @required this.isSelf,
    @required this.timestamp,
  });

  factory TextMessage.fromEntity(TextMessageEntity entity) {
    return TextMessage(
      id: entity.id,
      senderId: entity.senderId,
      text: entity.text,
      isSelf: entity.senderId ==
          CachedSharedPreferences.getString(PreferenceConstants.userId),
      timestamp: entity.timestamp,
    );
  }

  TextMessageEntity toEntity() {
    return TextMessageEntity(
      id: id,
      text: text,
      senderId: senderId,
      timestamp: timestamp,
    );
  }
}