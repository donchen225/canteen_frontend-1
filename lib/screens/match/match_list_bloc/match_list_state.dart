import 'package:equatable/equatable.dart';
import 'package:canteen_frontend/models/match/match.dart';

abstract class MatchListState extends Equatable {
  const MatchListState();

  @override
  List<Object> get props => [];
}

class MatchListUnauthenticated extends MatchListState {}

class MatchListLoading extends MatchListState {}

class MatchListLoaded extends MatchListState {
  final List<DetailedMatch> matchList;

  const MatchListLoaded(this.matchList);

  @override
  List<Object> get props => []..addAll(matchList);

  @override
  String toString() {
    return 'MatchListLoaded { matchList: $matchList }';
  }
}
