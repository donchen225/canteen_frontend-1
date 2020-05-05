import 'package:canteen_frontend/models/skill/skill.dart';
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

// Select an event from the user
class MatchEventSelecting extends MatchDetailState {}

// Select a time for the event
class MatchTimeSelecting extends MatchDetailState {
  final Skill skill;

  const MatchTimeSelecting(this.skill);

  @override
  List<Object> get props => [skill];

  @override
  String toString() => 'MatchTimeSelecting { skill: $skill }';
}

// Select a payment for the event
class MatchPaying extends MatchDetailState {
  final Skill skill;
  final VideoChatDate date;

  const MatchPaying({this.skill, this.date});

  @override
  List<Object> get props => [skill, date];

  @override
  String toString() => 'MatchPaying { skill: $skill, date: $date }';
}

// Initial time and payment have been completed
class MatchInitialized extends MatchDetailState {}

class MatchConfirmed extends MatchDetailState {}

class MatchCompleted extends MatchDetailState {}

class MatchError extends MatchDetailState {}
