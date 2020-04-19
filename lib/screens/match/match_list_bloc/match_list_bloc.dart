import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/match/match_list_bloc/bloc.dart';
import 'package:canteen_frontend/screens/match/match_bloc/bloc.dart';

class MatchListBloc extends Bloc<MatchListEvent, MatchListState> {
  final MatchBloc _matchBloc;
  StreamSubscription _matchSubscription;

  MatchListBloc({@required matchBloc})
      : assert(matchBloc != null),
        _matchBloc = matchBloc {
    _matchSubscription = matchBloc.listen((state) {
      if (state is MatchesLoaded) {
        add(LoadMatchList((matchBloc.state as MatchesLoaded).matches));
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
    if (event is LoadMatchList) {
      yield* _mapLoadMatchListToState(event);
    }
  }

  Stream<MatchListState> _mapLoadMatchListToState(LoadMatchList event) async* {
    yield MatchListLoading();
    yield MatchListLoaded(event.matchList);
  }

  @override
  Future<void> close() {
    _matchSubscription?.cancel();
    return super.close();
  }
}
