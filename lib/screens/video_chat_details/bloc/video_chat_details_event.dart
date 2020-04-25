import 'package:canteen_frontend/models/video_chat_date/video_chat_date.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class VideoChatDetailsEvent extends Equatable {
  const VideoChatDetailsEvent();

  @override
  List<Object> get props => [];
}

class LoadVideoChatDetails extends VideoChatDetailsEvent {
  final String matchId;
  final String videoChatId;

  const LoadVideoChatDetails({this.matchId, this.videoChatId});

  @override
  List<Object> get props => [];

  @override
  String toString() =>
      'LoadVideoChatDetails { matchId: $matchId videoChatId: $videoChatId }';
}

class ReceivedVideoChatDetails extends VideoChatDetailsEvent {
  final List<VideoChatDate> dates;

  const ReceivedVideoChatDetails(this.dates);

  @override
  List<Object> get props => [];

  @override
  String toString() => 'ReceivedVideoChatDetails { dates: $dates }';
}

class ProposeVideoChatDates extends VideoChatDetailsEvent {
  final String matchId;
  final String videoChatId;
  final List<VideoChatDate> dates;

  const ProposeVideoChatDates({
    @required this.matchId,
    @required this.videoChatId,
    @required this.dates,
  });

  @override
  List<Object> get props => [];

  @override
  String toString() => 'ProposeVideoChatDates { dates: $dates }';
}

class AcceptVideoChatDetails extends VideoChatDetailsEvent {}

class CompleteVideoChat extends VideoChatDetailsEvent {}
