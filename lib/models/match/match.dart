import 'package:canteen_frontend/models/match/match_entity.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:meta/meta.dart';

class Match {
  final String id;
  final Map<String, int> userId;
  final List<String> quizId;
  final List<String> messageId;

  Match({@required this.userId, this.quizId, this.messageId, this.id});

  static Match fromEntity(MatchEntity entity) {
    return Match(
      id: entity.id,
      userId: entity.userId,
      quizId: entity.quizId,
      messageId: entity.messageId,
    );
  }

  MatchEntity toEntity() {
    return MatchEntity(
      id: id,
      userId: userId,
      quizId: quizId,
      messageId: messageId,
    );
  }
}

class DetailedMatch extends Match {
  final List<User> userList;

  DetailedMatch(
      {@required userId,
      @required id,
      @required quizId,
      @required messageId,
      @required this.userList})
      : super(userId: userId, id: id, quizId: quizId, messageId: messageId);

  static DetailedMatch fromMatch(Match match, List<User> userList) {
    return DetailedMatch(
        userId: match.userId,
        id: match.id,
        quizId: match.quizId,
        messageId: match.messageId,
        userList: userList);
  }
}
