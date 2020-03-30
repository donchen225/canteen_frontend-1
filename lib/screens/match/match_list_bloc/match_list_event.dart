import 'package:equatable/equatable.dart';
import 'package:canteen_frontend/models/match/match.dart';

abstract class MatchListEvent extends Equatable {
  const MatchListEvent();
}

class UpdateMatchList extends MatchListEvent {
  final List<Match> matchList;

  const UpdateMatchList(this.matchList);

  @override
  List<Object> get props => [matchList];

  @override
  String toString() => 'UpdateMatchList { matchList: $matchList }';
}
