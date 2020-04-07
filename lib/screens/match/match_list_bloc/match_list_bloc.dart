import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:canteen_frontend/models/match/match.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/match/match_list_bloc/bloc.dart';
import 'package:canteen_frontend/screens/match/match_bloc/bloc.dart';

class MatchListBloc extends Bloc<MatchListEvent, MatchListState> {
  final MatchBloc _matchBloc;
  final UserRepository _userRepository;
  StreamSubscription _matchSubscription;

  MatchListBloc({@required matchBloc, @required userRepository})
      : assert(matchBloc != null),
        assert(userRepository != null),
        _matchBloc = matchBloc,
        _userRepository = userRepository {
    _matchSubscription = matchBloc.listen((state) {
      if (state is MatchesLoaded) {
        add(UpdateMatchList((matchBloc.state as MatchesLoaded).matches));
      }
    });
  }

  @override
  MatchListState get initialState {
    final currentState = _matchBloc.state;
    return currentState is MatchesLoaded
        ? MatchListLoaded(currentState.matches)
        : MatchListLoading();
  }

  @override
  Stream<MatchListState> mapEventToState(MatchListEvent event) async* {
    if (event is UpdateMatchList) {
      yield* _mapMatchListUpdatedToState(event);
    }
  }

  // Get details for matches in MatchList
  Stream<MatchListState> _mapMatchListUpdatedToState(
    UpdateMatchList event,
  ) async* {
    yield DetailedMatchListLoaded(await _getDetailedMatchList(
        (_matchBloc.state as MatchesLoaded).matches));
  }

  @override
  Future<void> close() {
    _matchSubscription?.cancel();
    return super.close();
  }

  Future<List<DetailedMatch>> _getDetailedMatchList(
      List<Match> matchList) async {
    var userCache = Map<String, User>();

    return Future.wait(matchList.map((match) async {
      return Future.wait(match.userId.keys.map((id) async {
        if (userCache.containsKey(id)) {
          return userCache[id];
        }

        var u = await _userRepository.currentUser();
        if (!userCache.containsKey(id)) {
          userCache[u.id] = u;
        }
        return u;
      })).then((userList) => DetailedMatch.fromMatch(match, userList));
    }));
  }
}
