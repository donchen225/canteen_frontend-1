import 'package:canteen_frontend/models/message/message.dart';
import 'package:canteen_frontend/models/match/match_entity.dart';
import 'package:canteen_frontend/models/match/status.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Match extends Equatable {
  final String id;
  final List<String> userId;
  final String senderId;
  final MatchStatus status;
  final String payer;
  final DateTime time;
  final Map<String, bool> read;
  final DateTime createdOn;
  final DateTime lastUpdated;

  Match({
    @required this.userId,
    this.senderId,
    this.id,
    this.status,
    this.payer,
    this.time,
    this.read,
    this.createdOn,
    this.lastUpdated,
  });

  @override
  List<Object> get props => [
        id,
        userId,
        senderId,
        status,
        payer,
        time,
        read,
        createdOn,
        lastUpdated,
      ];

  static Match fromEntity(MatchEntity entity) {
    return Match(
      id: entity.id,
      userId: entity.userId,
      senderId: entity.senderId,
      status: MatchStatus.values[entity.status],
      payer: entity.payer,
      time: entity.time,
      read: entity.read,
      createdOn: entity.createdOn,
      lastUpdated: entity.lastUpdated,
    );
  }
}

class DetailedMatch extends Match with EquatableMixin {
  final List<User> userList;
  final Message lastMessage;

  DetailedMatch(
      {@required userId,
      @required senderId,
      @required id,
      @required status,
      @required payer,
      @required time,
      @required read,
      @required createdOn,
      @required lastUpdated,
      @required this.userList,
      this.lastMessage})
      : super(
            userId: userId,
            senderId: senderId,
            id: id,
            status: status,
            payer: payer,
            time: time,
            read: read,
            lastUpdated: lastUpdated,
            createdOn: createdOn);

  @override
  List<Object> get props => [
        id,
        userId,
        senderId,
        status,
        payer,
        time,
        read,
        createdOn,
        lastUpdated,
        userList,
        lastMessage
      ];

  static DetailedMatch fromMatch(Match match, List<User> userList,
      {Message lastMessage}) {
    return DetailedMatch(
        userId: match.userId,
        senderId: match.senderId,
        id: match.id,
        status: match.status,
        payer: match.payer,
        time: match.time,
        read: match.read,
        createdOn: match.createdOn,
        userList: userList,
        lastUpdated: match.lastUpdated,
        lastMessage: lastMessage);
  }
}
