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
    } else if (entity is SystemMessageEntity) {
      message = SystemMessage.fromEntity(entity);
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
  final Map<String, dynamic> data;
  final bool isSelf;
  final bool isItalics;
  final DateTime timestamp;

  TextMessage({
    this.id,
    @required this.senderId,
    @required this.text,
    @required this.data,
    @required this.isSelf,
    @required this.isItalics,
    @required this.timestamp,
  });

  factory TextMessage.fromEntity(TextMessageEntity entity) {
    final userId =
        CachedSharedPreferences.getString(PreferenceConstants.userId);

    String text = '';
    bool isItalics = false;
    if (entity.data != null) {
      final senderMessage = entity.data["sender"];
      final receiverMessage = entity.data["receiver"];

      if (senderMessage != null && receiverMessage != null) {
        text = entity.senderId == userId ? receiverMessage : senderMessage;
        isItalics = true;
      }
    }

    return TextMessage(
      id: entity.id,
      senderId: entity.senderId,
      text: entity.text != null ? entity.text : text,
      data: entity.data,
      isSelf: entity.senderId == userId,
      isItalics: isItalics,
      timestamp: entity.timestamp,
    );
  }

  TextMessageEntity toEntity() {
    return TextMessageEntity(
      id: id,
      text: text,
      data: data,
      senderId: senderId,
      timestamp: timestamp,
    );
  }
}

@immutable
class SystemMessage extends Message {
  final String id;
  final String senderId;
  final String text;
  final Map<String, dynamic> data;
  final String event;
  final bool isSelf;
  final DateTime timestamp;

  SystemMessage({
    this.id,
    @required this.senderId,
    @required this.text,
    @required this.data,
    @required this.event,
    @required this.isSelf,
    @required this.timestamp,
  });

  factory SystemMessage.fromEntity(SystemMessageEntity entity) {
    return SystemMessage(
      id: entity.id,
      senderId: entity.senderId,
      text: entity.text,
      data: entity.data,
      event: entity.event,
      isSelf: entity.senderId ==
          CachedSharedPreferences.getString(PreferenceConstants.userId),
      timestamp: entity.timestamp,
    );
  }

  SystemMessageEntity toEntity() {
    return SystemMessageEntity(
      id: id,
      text: text,
      data: data,
      event: event,
      senderId: senderId,
      timestamp: timestamp,
    );
  }
}
