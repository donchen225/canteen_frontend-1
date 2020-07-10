import 'dart:async';

import 'package:canteen_frontend/models/message/message.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:canteen_frontend/models/match/match.dart';
import 'package:meta/meta.dart';
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
      @required UserRepository userRepository})
      : assert(matchRepository != null),
        assert(userRepository != null),
        _matchRepository = matchRepository,
        _userRepository = userRepository;

  // TODO: load local matches
  @override
  MatchState get initialState => MatchesUnauthenticated();

  @override
  Stream<MatchState> mapEventToState(MatchEvent event) async* {
    if (event is LoadMatches) {
      yield* _mapLoadMatchesToState();
    } else if (event is MatchesUpdated) {
      yield* _mapMatchesUpdateToState(event);
    } else if (event is ClearMatches) {
      yield* _mapClearMatchesToState();
    }
  }

  Stream<MatchState> _mapLoadMatchesToState() async* {
    try {
      print('LOADING MATCHES');
      _matchSubscription?.cancel();
      _matchSubscription = _matchRepository.getMatches().listen((matches) {
        print('RECEIVED MATCH EVENT');
        add(MatchesUpdated(matches));
      });
    } catch (exception) {
      print(exception.errorMessage());
    }
  }

  Stream<MatchState> _mapMatchesUpdateToState(MatchesUpdated event) async* {
    yield MatchesLoading();
    final updatedMatches = event.updates;
    final messageListFuture = Future.wait(updatedMatches.map((update) {
      if (update.item1 == DocumentChangeType.modified ||
          update.item1 == DocumentChangeType.added) {
        return _matchRepository
            .getMessage(update.item2.id)
            .catchError((w) => Future<Message>.value(null));
      }
      return Future<Message>.value(null);
    }).toList());

    final userListFuture = Future.wait(updatedMatches.map((update) async {
      if (update.item1 == DocumentChangeType.modified ||
          update.item1 == DocumentChangeType.added) {
        return Future.wait(update.item2.userId.map((id) async {
          var u = await _userRepository.getUser(id);
          return u;
        }));
      }
      return Future<List<User>>.value(null);
    }));

    final messageList = await messageListFuture;
    final userList = await userListFuture;

    for (int i = 0; i < updatedMatches.length; i++) {
      List<User> users = userList[i];
      Tuple2<DocumentChangeType, Match> update = updatedMatches[i];

      if (update.item1 == DocumentChangeType.added ||
          update.item1 == DocumentChangeType.modified) {
        Message message = messageList[i];

        final detailedMatch =
            DetailedMatch.fromMatch(update.item2, users, lastMessage: message);

        if (update.item1 == DocumentChangeType.added) {
          _matchRepository.saveDetailedMatch(detailedMatch);
        } else {
          _matchRepository.updateDetailedMatch(update.item1, detailedMatch);
        }
      } else if (update.item1 == DocumentChangeType.removed) {
        _matchRepository.updateDetailedMatch(update.item1, update.item2);
      }
    }

    yield MatchesLoaded(_matchRepository.currentDetailedMatches());
  }

  Stream<MatchState> _mapClearMatchesToState() async* {
    _matchRepository.clearMatches();
    _matchSubscription?.cancel();
    yield MatchesUnauthenticated();
  }

  @override
  Future<void> close() {
    _matchRepository.clearMatches();
    _matchSubscription?.cancel();
    return super.close();
  }
}
