import 'package:canteen_frontend/models/chat/chat_entity.dart';
import 'package:meta/meta.dart';

@immutable
class Chat {
  final String id;
  final List<String> userId;
  final DateTime lastUpdated;

  Chat({
    @required this.id,
    @required this.userId,
    @required this.lastUpdated,
  });

  static Chat fromEntity(ChatEntity entity) {
    return Chat(
      id: entity.id,
      userId: entity.userId,
      lastUpdated: entity.lastUpdated,
    );
  }

  ChatEntity toEntity() {
    return ChatEntity(
      id: id,
      userId: userId,
      lastUpdated: lastUpdated,
    );
  }
}
