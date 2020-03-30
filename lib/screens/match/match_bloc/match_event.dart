import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:canteen_frontend/models/match/match.dart';
import 'package:tuple/tuple.dart';
import 'package:meta/meta.dart';

abstract class MatchEvent extends Equatable {
  const MatchEvent();

  @override
  List<Object> get props => [];
}

class LoadMatches extends MatchEvent {
  final String userId;

  const LoadMatches(this.userId);

  @override
  List<Object> get props => [userId];

  @override
  String toString() => 'LoadMatches { userId: $userId }';
}

class AddMatch extends MatchEvent {
  final Match match;

  const AddMatch(this.match);

  @override
  List<Object> get props => [match];

  @override
  String toString() => 'AddMatch { match: $match }';
}

class UpdateMatch extends MatchEvent {
  final Match updatedMatch;

  const UpdateMatch(this.updatedMatch);

  @override
  List<Object> get props => [updatedMatch];

  @override
  String toString() => 'UpdateMatch { updatedMatch: $updatedMatch }';
}

class AddQuizToMatch extends MatchEvent {
  final String matchId;
  final String quizId;

  const AddQuizToMatch({@required this.quizId, @required this.matchId});

  @override
  List<Object> get props => [matchId, quizId];

  @override
  String toString() => 'AddQuizToMatch { matchId: $matchId, quizId: $quizId }';
}

class DeleteMatch extends MatchEvent {
  final Match match;

  const DeleteMatch(this.match);

  @override
  List<Object> get props => [match];

  @override
  String toString() => 'DeleteMatch { match: $match }';
}

class MatchesUpdated extends MatchEvent {
  final List<Tuple2<DocumentChangeType, Match>> matchesChanged;

  const MatchesUpdated(this.matchesChanged);

  @override
  List<Object> get props => [matchesChanged];

  @override
  String toString() => 'MatchesUpdated { matchesChanged: $matchesChanged }';
}

class ClearMatches extends MatchEvent {}
