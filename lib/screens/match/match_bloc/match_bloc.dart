import 'dart:async';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:canteen_frontend/models/match/match.dart';
import 'package:meta/meta.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:canteen_frontend/models/match/match_repository.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/match/match_bloc/bloc.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  final MatchRepository _matchRepository;
  final UserRepository _userRepository;
  StreamSubscription _matchSubscription;

  MatchBloc(
      {@required MatchRepository matchRepository,
      @required UserRepository userRepository})
      : assert(matchRepository != null),
        assert(userRepository != null),
        _matchRepository = matchRepository,
        _userRepository = userRepository;

  // TODO: load local matches
  @override
  MatchState get initialState => MatchesLoaded([]);

  @override
  Stream<MatchState> mapEventToState(MatchEvent event) async* {
    if (event is LoadMatches) {
      yield* _mapLoadMatchesToState();
    } else if (event is AddMatch) {
      yield* _mapAddMatchToState(event);
    } else if (event is DeleteMatch) {
      yield* _mapDeleteMatchToState(event);
    } else if (event is MatchesUpdated) {
      yield* _mapMatchesUpdateToState(event);
    } else if (event is ClearMatches) {
      yield* _mapClearMatchesToState();
    }
  }

  Stream<MatchState> _mapLoadMatchesToState() async* {
    _matchSubscription?.cancel();
    final userId =
        CachedSharedPreferences.getString(PreferenceConstants.userId);
    _matchSubscription =
        _matchRepository.getAllMatches(userId).listen((matches) {
      print('RECEIVED MATCH EVENT');
      add(MatchesUpdated(matches));
    });
  }

  Stream<MatchState> _mapAddMatchToState(AddMatch event) async* {
    try {
      // Check local matches if match already exists
      if ((state as MatchesLoaded)
          .matches
          .where((match) => DeepCollectionEquality.unordered()
              .equals(match.userId, event.match.userId))
          .isNotEmpty) {
        return;
      }

      _matchRepository.addMatch(event.match);
    } catch (_) {
      print('FAILED TO ADD MATCH');
    }
  }

  Stream<MatchState> _mapDeleteMatchToState(DeleteMatch event) async* {
    _matchRepository.deleteMatch(event.match);
  }

  Stream<MatchState> _mapMatchesUpdateToState(MatchesUpdated event) async* {
    // TODO: remove this hack
    // For some reason changes to this variable modify the current MatchState
    // State should only be MatchesLoading during app startup
    List<Match> matchList = (state is MatchesLoaded)
        ? List<Match>.from((state as MatchesLoaded).matches)
        : [];

    event.matchesChanged.forEach((matchChange) {
      if (matchChange.item1 == DocumentChangeType.added) {
        matchList.insert(0, matchChange.item2);
      } else if (matchChange.item1 == DocumentChangeType.modified) {
        matchList.removeWhere((match) => match.id == matchChange.item2.id);
        matchList.insert(0, matchChange.item2);
      } else if (matchChange.item1 == DocumentChangeType.removed) {
        matchList.removeWhere((match) => match.id == matchChange.item2.id);
      }
    });

    yield MatchesLoaded(matchList);
  }

  Stream<MatchState> _mapClearMatchesToState() async* {
    _matchSubscription?.cancel();
    yield MatchesNotLoaded();
  }

  @override
  Future<void> close() {
    _matchSubscription?.cancel();
    return super.close();
  }
}
