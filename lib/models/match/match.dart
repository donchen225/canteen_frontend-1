import 'package:canteen_frontend/models/match/match_entity.dart';
import 'package:canteen_frontend/models/match/status.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:meta/meta.dart';

@immutable
class Match {
  final String id;
  final Map<String, int> userId;
  final List<String> messageId;
  final MatchStatus status;

  Match({@required this.userId, this.messageId, this.id, this.status});

  static Match fromEntity(MatchEntity entity) {
    return Match(
      id: entity.id,
      userId: entity.userId,
      messageId: entity.messageId,
      status: MatchStatus.values[entity.status],
    );
  }

  MatchEntity toEntity() {
    return MatchEntity(
      id: id,
      userId: userId,
      messageId: messageId,
      status: status.index,
    );
  }
}

class DetailedMatch extends Match {
  final List<User> userList;

  DetailedMatch(
      {@required userId,
      @required id,
      @required messageId,
      @required status,
      @required this.userList})
      : super(userId: userId, id: id, messageId: messageId, status: status);

  static DetailedMatch fromMatch(Match match, List<User> userList) {
    return DetailedMatch(
        userId: match.userId,
        id: match.id,
        messageId: match.messageId,
        status: match.status,
        userList: userList);
  }
}
