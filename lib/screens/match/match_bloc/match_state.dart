import 'package:equatable/equatable.dart';
import 'package:canteen_frontend/models/match/match.dart';

abstract class MatchState extends Equatable {
  const MatchState();

  @override
  List<Object> get props => [];
}

class MatchesLoading extends MatchState {}

class MatchesLoaded extends MatchState {
  final List<DetailedMatch> matches;

  const MatchesLoaded([this.matches = const []]);

  @override
  List<Object> get props => [matches];

  @override
  String toString() => 'MatchesLoaded { matches: $matches }';
}

class MatchesUnauthenticated extends MatchState {}
