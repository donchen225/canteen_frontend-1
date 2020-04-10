import 'package:canteen_frontend/models/chat/chat_entity.dart';
import 'package:canteen_frontend/models/chat/message.dart';
import 'package:meta/meta.dart';

@immutable
class Chat {
  final String id;
  final List<String> userId;
  final DateTime lastUpdated;
  final DateTime createdOn;
  final Message lastMessage;

  Chat({
    @required this.id,
    @required this.userId,
    @required this.lastUpdated,
    @required this.createdOn,
    this.lastMessage,
  });

  static Chat create({List<String> userId}) {
    return Chat(
      id: userId[0].hashCode < userId[1].hashCode
          ? userId[0] + userId[1]
          : userId[1] + userId[0],
      userId: userId..sort((a, b) => a.hashCode.compareTo(b.hashCode)),
      lastUpdated: DateTime.now().toUtc(),
      createdOn: DateTime.now().toUtc(),
    );
  }

  static Chat fromEntity(ChatEntity entity, {Message lastMessage}) {
    return Chat(
      id: entity.id,
      userId: entity.userId,
      lastUpdated: entity.lastUpdated,
      createdOn: entity.createdOn,
      lastMessage: lastMessage,
    );
  }

  ChatEntity toEntity() {
    return ChatEntity(
      id: id,
      userId: userId,
      lastUpdated: lastUpdated,
      createdOn: createdOn,
    );
  }

  Chat addLastMessage(Message message) {
    return Chat(
        id: id,
        userId: userId,
        lastUpdated: lastUpdated,
        createdOn: createdOn,
        lastMessage: message);
  }
}
