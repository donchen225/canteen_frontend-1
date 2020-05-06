import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/models/video_chat_date/video_chat_date.dart';
import 'package:canteen_frontend/models/match/match.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class MatchDetailEvent extends Equatable {
  const MatchDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadMatchDetails extends MatchDetailEvent {
  final Match match;

  const LoadMatchDetails({this.match});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'LoadMatchDetails { match: ${match.id} }';
}

class SelectEvent extends MatchDetailEvent {
  final Skill skill;

  const SelectEvent(this.skill);

  @override
  List<Object> get props => [skill];

  @override
  String toString() => 'SelectEvent { skill: $skill }';
}

class ReceivedVideoChatDetails extends MatchDetailEvent {
  final List<VideoChatDate> dates;

  const ReceivedVideoChatDetails(this.dates);

  @override
  List<Object> get props => [];

  @override
  String toString() => 'ReceivedVideoChatDetails { dates: $dates }';
}

class SelectVideoChatDate extends MatchDetailEvent {
  final String matchId;
  final String videoChatId;
  final Skill skill;
  final VideoChatDate date;

  const SelectVideoChatDate({
    @required this.matchId,
    @required this.videoChatId,
    @required this.skill,
    @required this.date,
  });

  @override
  List<Object> get props => [matchId, videoChatId, skill, date];

  @override
  String toString() => 'SelectVideoChatDate { skill: $skill, date: $date }';
}

class SelectPayment extends MatchDetailEvent {
  final String paymentMethod;
  final Skill skill;

  const SelectPayment({
    @required this.paymentMethod,
    @required this.skill,
  });

  @override
  List<Object> get props => [paymentMethod, skill];

  @override
  String toString() =>
      'SelectPayment { paymentMethod: $paymentMethod skill: $skill }';
}

class ConfirmPayment extends MatchDetailEvent {
  final Match match;

  const ConfirmPayment({
    @required this.match,
  });

  @override
  List<Object> get props => [match];

  @override
  String toString() => 'ConfirmPayment { match: $match }';
}

class AcceptVideoChatDetails extends MatchDetailEvent {}

class CompleteVideoChat extends MatchDetailEvent {}
