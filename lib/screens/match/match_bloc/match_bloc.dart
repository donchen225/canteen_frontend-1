import 'dart:async';
import 'package:canteen_frontend/models/match/status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:canteen_frontend/models/match/match.dart';
import 'package:meta/meta.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:canteen_frontend/models/match/match_repository.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/match/match_bloc/bloc.dart';
import 'package:tuple/tuple.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  final MatchRepository _matchRepository;
  final UserRepository _userRepository;
  StreamSubscription _matchSubscription;

  MatchBloc(
      {@required MatchRepository matchRepository,
      @required UserRepository userRepository}) // TODO: add QuizRepository
      : assert(matchRepository != null),
        assert(userRepository != null),
        _matchRepository = matchRepository,
        _userRepository = userRepository;
  // {_quizSubscription = _quizBloc.listen((state) {
  //   if (state is QuizWaitingResponse) {
  //     print('MATCH BLOC: QUIZ WAITING RESPONSE');
  //     add(LoadUser(state.user));
  //   }
  // });

  // TODO: load local matches
  @override
  MatchState get initialState => MatchesLoaded([]);

  @override
  Stream<MatchState> mapEventToState(MatchEvent event) async* {
    if (event is LoadMatches) {
      yield* _mapLoadMatchesToState(event);
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

  Stream<MatchState> _mapLoadMatchesToState(LoadMatches event) async* {
    _matchSubscription?.cancel();
    _matchSubscription =
        _matchRepository.getAllMatches(event.userId).listen((matches) {
      print('RECEIVED MATCH EVENT');
      List<Tuple2<DocumentChangeType, Match>> matchList = [];
      List<Tuple2<DocumentChangeType, Match>> requestList = [];

      matches.forEach((change) {
        if (change.item2.status == MatchStatus.initialized) {
          requestList.add(change);
        }

        if (change.item2.status == MatchStatus.accepted) {
          matchList.add(change);
        }
      });

      if (matchList.length > 0) {
        add(MatchesUpdated(matchList));
      }

      if (requestList.length > 0) {
        print('REQUEST LIST');
      }
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

  // Stream<MatchesState> _mapUpdateTodoToState(UpdateTodo event) async* {
  //   _matchRepository.updateMatch(event.updatedTodo);
  // }

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
