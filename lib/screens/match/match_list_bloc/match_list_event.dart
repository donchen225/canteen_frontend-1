import 'package:equatable/equatable.dart';
import 'package:canteen_frontend/models/match/match.dart';

abstract class MatchListEvent extends Equatable {
  const MatchListEvent();
}

class LoadMatchList extends MatchListEvent {
  final List<DetailedMatch> matchList;

  const LoadMatchList(this.matchList);

  @override
  List<Object> get props => [matchList];

  @override
  String toString() => 'LoadMatchList { matchList: $matchList }';
}
