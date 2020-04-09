import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ChatEntity extends Equatable {
  final String id;
  final List<String> userId;
  final DateTime lastUpdated;

  const ChatEntity(
      {@required this.id, @required this.userId, @required this.lastUpdated});

  @override
  List<Object> get props => [id, userId, lastUpdated];

  @override
  String toString() {
    return 'ChatEntity { id: $id, userId: $userId, lastUpdated: $lastUpdated }';
  }

  Map<String, Object> toDocument() {
    return {
      'user_id': userId,
      'last_updated': lastUpdated,
    };
  }
}
