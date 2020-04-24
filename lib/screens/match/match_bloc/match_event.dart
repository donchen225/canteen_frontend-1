import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:canteen_frontend/models/match/match.dart';
import 'package:tuple/tuple.dart';

abstract class MatchEvent extends Equatable {
  const MatchEvent();

  @override
  List<Object> get props => [];
}

class LoadMatches extends MatchEvent {
  const LoadMatches();

  @override
  String toString() => 'LoadMatches';
}

class UpdateMatch extends MatchEvent {
  final Match updatedMatch;

  const UpdateMatch(this.updatedMatch);

  @override
  List<Object> get props => [updatedMatch];

  @override
  String toString() => 'UpdateMatch { updatedMatch: $updatedMatch }';
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
  final List<Tuple2<DocumentChangeType, Match>> updates;

  const MatchesUpdated(this.updates);

  @override
  List<Object> get props => [updates];

  @override
  String toString() => 'MatchesUpdated { updates: $updates }';
}

class ClearMatches extends MatchEvent {}
