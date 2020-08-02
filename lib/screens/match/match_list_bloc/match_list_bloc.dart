import 'dart:async';

import 'package:canteen_frontend/models/match/match.dart';
import 'package:canteen_frontend/models/match/match_repository.dart';
import 'package:canteen_frontend/models/message/message.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:canteen_frontend/screens/match/match_list_bloc/bloc.dart';
import 'package:canteen_frontend/screens/match/match_bloc/bloc.dart';

class MatchListBloc extends Bloc<MatchListEvent, MatchListState> {
  List<DetailedMatch> _matchList = [];
  final MatchBloc _matchBloc;
  StreamSubscription _matchSubscription;
  final MatchRepository _matchRepository;

  MatchListBloc({
    @required matchBloc,
    @required matchRepository,
  })  : assert(matchBloc != null),
        assert(matchRepository != null),
        _matchBloc = matchBloc,
        _matchRepository = matchRepository {
    _matchSubscription = _matchBloc.listen((matchState) {
      if (matchState is MatchesLoaded) {
        add(LoadMatchList(matchState.matches));
      }
    });
  }

  @override
  MatchListState get initialState => MatchListUnauthenticated();

  @override
  Stream<MatchListState> mapEventToState(MatchListEvent event) async* {
    if (event is LoadMatchList) {
      yield* _mapLoadMatchListToState(event);
    } else if (event is ReadMatch) {
      yield* _mapReadMatchToState(event);
    } else if (event is ClearMatchList) {
      yield* _mapClearMatchListToState();
    }
  }

  Stream<MatchListState> _mapLoadMatchListToState(LoadMatchList event) async* {
    final updatedList = List.of(event.matchList);
    _matchList = updatedList;

    yield MatchListLoaded(updatedList);
  }

  Stream<MatchListState> _mapReadMatchToState(ReadMatch event) async* {
    final idx = _matchList.indexWhere((m) => m.id == event.matchId);

    if (idx >= 0) {
      final userId =
          CachedSharedPreferences.getString(PreferenceConstants.userId);
      final match = _matchList[idx];

      if (match.read.isEmpty ||
          match.read[userId] == null ||
          !match.read[userId]) {
        match.read[userId] = true;
        _matchRepository.readMatch(event.matchId);
      }

      yield MatchListLoaded(_matchList);
    }
  }

  Stream<MatchListState> _mapClearMatchListToState() async* {
    yield MatchListUnauthenticated();
  }

  @override
  Future<void> close() {
    _matchSubscription?.cancel();
    return super.close();
  }
}
