import 'package:canteen_frontend/models/match/match_entity.dart';
import 'package:canteen_frontend/models/match/status.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:meta/meta.dart';

@immutable
class Match {
  final String id;
  final Map<String, int> userId;
  final String chatId;
  final MatchStatus status;
  final DateTime createdOn;

  Match(
      {@required this.userId,
      this.chatId,
      this.id,
      this.status,
      this.createdOn});

  static Match create({List<String> userId}) {
    return Match(
      userId: Map.fromEntries(userId.map((v) => MapEntry(v, 0))),
      chatId: userId[0].hashCode < userId[1].hashCode
          ? userId[0] + userId[1]
          : userId[1] + userId[0],
      status: MatchStatus.initialized,
      createdOn: DateTime.now().toUtc(),
    );
  }

  static Match fromEntity(MatchEntity entity) {
    return Match(
      id: entity.id,
      userId: entity.userId,
      chatId: entity.chatId,
      status: MatchStatus.values[entity.status],
      createdOn: entity.createdOn,
    );
  }

  MatchEntity toEntity() {
    return MatchEntity(
      id: id,
      userId: userId,
      chatId: chatId,
      status: status.index,
      createdOn: createdOn,
    );
  }
}

class DetailedMatch extends Match {
  final List<User> userList;

  DetailedMatch(
      {@required userId,
      @required id,
      @required chatId,
      @required status,
      @required createdOn,
      @required this.userList})
      : super(
            userId: userId,
            id: id,
            chatId: chatId,
            status: status,
            createdOn: createdOn);

  static DetailedMatch fromMatch(Match match, List<User> userList) {
    return DetailedMatch(
        userId: match.userId,
        id: match.id,
        chatId: match.chatId,
        status: match.status,
        createdOn: match.createdOn,
        userList: userList);
  }
}
