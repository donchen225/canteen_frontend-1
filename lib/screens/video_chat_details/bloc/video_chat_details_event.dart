import 'package:canteen_frontend/models/video_chat_date/video_chat_date.dart';
import 'package:equatable/equatable.dart';

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
  final List<VideoChatDate> videoChatDates;

  const ReceivedVideoChatDetails(this.videoChatDates);

  @override
  List<Object> get props => [];

  @override
  String toString() =>
      'ReceivedVideoChatDetails { videoChatDates: $videoChatDates }';
}

class ProposeVideoChatDetails extends VideoChatDetailsEvent {}

class AcceptVideoChatDetails extends VideoChatDetailsEvent {}

class CompleteVideoChat extends VideoChatDetailsEvent {}
