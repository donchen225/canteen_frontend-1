import 'package:canteen_frontend/models/video_chat_date/video_chat_date.dart';
import 'package:equatable/equatable.dart';

abstract class MatchDetailState extends Equatable {
  const MatchDetailState();

  @override
  List<Object> get props => [];
}

// Screen to select initial time
class MatchUninitialized extends MatchDetailState {}

class MatchLoading extends MatchDetailState {}

// Waiting for other user to select time and pay
class MatchWaiting extends MatchDetailState {}

class MatchTimeSelecting extends MatchDetailState {}

// Initial time has been selected, requires user payment
class MatchTimeSelected extends MatchDetailState {
  final VideoChatDate date;

  const MatchTimeSelected({this.date});

  @override
  List<Object> get props => [date];

  @override
  String toString() => 'MatchTimeSelected { date: $date }';
}

// Initial time and payment have been completed
class MatchInitialized extends MatchDetailState {}

class MatchConfirmed extends MatchDetailState {}

class MatchCompleted extends MatchDetailState {}

class MatchError extends MatchDetailState {}
