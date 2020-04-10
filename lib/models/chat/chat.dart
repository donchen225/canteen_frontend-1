import 'package:canteen_frontend/models/chat/chat_entity.dart';
import 'package:meta/meta.dart';

@immutable
class Chat {
  final String id;
  final Map<String, int> userId;
  final DateTime lastUpdated;
  final DateTime createdOn;

  Chat({
    @required this.id,
    @required this.userId,
    @required this.lastUpdated,
    @required this.createdOn,
  });

  static Chat create({List<String> userId}) {
    return Chat(
      id: userId[0].hashCode < userId[1].hashCode
          ? userId[0] + userId[1]
          : userId[1] + userId[0],
      userId: Map.fromEntries(
        userId.map((v) => MapEntry(v, 0)),
      ),
      lastUpdated: DateTime.now().toUtc(),
      createdOn: DateTime.now().toUtc(),
    );
  }

  static Chat fromEntity(ChatEntity entity) {
    return Chat(
      id: entity.id,
      userId: entity.userId,
      lastUpdated: entity.lastUpdated,
      createdOn: entity.createdOn,
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
}
