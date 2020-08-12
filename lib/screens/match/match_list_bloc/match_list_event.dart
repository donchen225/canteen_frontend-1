import 'package:equatable/equatable.dart';
import 'package:canteen_frontend/models/match/match.dart';

abstract class MatchListEvent extends Equatable {
  const MatchListEvent();

  @override
  List<Object> get props => [];
}

class LoadMatchList extends MatchListEvent {
  final List<DetailedMatch> matchList;

  const LoadMatchList(this.matchList);

  @override
  List<Object> get props => []..addAll(matchList);

  @override
  String toString() => 'LoadMatchList';
}

class ReadMatch extends MatchListEvent {
  final String matchId;

  const ReadMatch(this.matchId);

  @override
  List<Object> get props => [matchId];

  @override
  String toString() => 'ReadMatch { matchId: $matchId }';
}

class ClearMatchList extends MatchListEvent {}
