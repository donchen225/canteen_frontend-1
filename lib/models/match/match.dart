import 'package:canteen_frontend/models/message/message.dart';
import 'package:canteen_frontend/models/match/match_entity.dart';
import 'package:canteen_frontend/models/match/status.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:meta/meta.dart';

@immutable
class Match {
  final String id;
  final List<String> userId;
  final MatchStatus status;
  final String activeVideoChat;
  final DateTime createdOn;
  final DateTime lastUpdated;

  Match({
    @required this.userId,
    this.id,
    this.status,
    this.activeVideoChat,
    this.createdOn,
    this.lastUpdated,
  });

  static Match fromEntity(MatchEntity entity, {Message lastMessage}) {
    return Match(
      id: entity.id,
      userId: entity.userId,
      status: MatchStatus.values[entity.status],
      activeVideoChat: entity.activeVideoChat,
      createdOn: entity.createdOn,
      lastUpdated: entity.lastUpdated,
    );
  }

  MatchEntity toEntity() {
    return MatchEntity(
      id: id,
      userId: userId,
      status: status.index,
      activeVideoChat: activeVideoChat,
      lastUpdated: lastUpdated,
      createdOn: createdOn,
    );
  }
}

class DetailedMatch extends Match {
  final List<User> userList;
  final Message lastMessage;

  DetailedMatch(
      {@required userId,
      @required id,
      @required status,
      @required activeVideoChat,
      @required createdOn,
      @required lastUpdated,
      @required this.userList,
      this.lastMessage})
      : super(
            userId: userId,
            id: id,
            status: status,
            activeVideoChat: activeVideoChat,
            lastUpdated: lastUpdated,
            createdOn: createdOn);

  static DetailedMatch fromMatch(Match match, List<User> userList,
      {Message lastMessage}) {
    return DetailedMatch(
        userId: match.userId,
        id: match.id,
        status: match.status,
        activeVideoChat: match.activeVideoChat,
        createdOn: match.createdOn,
        userList: userList,
        lastUpdated: match.lastUpdated,
        lastMessage: lastMessage);
  }
}
