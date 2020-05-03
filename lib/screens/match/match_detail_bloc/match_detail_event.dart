import 'package:canteen_frontend/models/video_chat_date/video_chat_date.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class MatchDetailEvent extends Equatable {
  const MatchDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadMatchDetails extends MatchDetailEvent {
  final String matchId;
  final String videoChatId;

  const LoadMatchDetails({this.matchId, this.videoChatId});

  @override
  List<Object> get props => [];

  @override
  String toString() =>
      'LoadMatchDetails { matchId: $matchId videoChatId: $videoChatId }';
}

class ViewVideoChatDates extends MatchDetailEvent {}

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
  final VideoChatDate date;

  const SelectVideoChatDate({
    @required this.matchId,
    @required this.videoChatId,
    @required this.date,
  });

  @override
  List<Object> get props => [];

  @override
  String toString() => 'SelectVideoChatDate { date: $date }';
}

class AcceptVideoChatDetails extends MatchDetailEvent {}

class CompleteVideoChat extends MatchDetailEvent {}
