import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:canteen_frontend/screens/match/match_list_bloc/bloc.dart';
import 'package:canteen_frontend/screens/match/match_bloc/bloc.dart';

class MatchListBloc extends Bloc<MatchListEvent, MatchListState> {
  final MatchBloc _matchBloc;
  StreamSubscription _matchSubscription;

  MatchListBloc({@required matchBloc})
      : assert(matchBloc != null),
        _matchBloc = matchBloc {
    _matchSubscription = matchBloc.listen((state) {
      print('MATCH BLOC STATE: $state');

      if (state is MatchesLoaded) {
        add(LoadMatchList((matchBloc.state as MatchesLoaded).matches));
      } else if (state is MatchesUnauthenticated) {
        print('MATCHES UNAUTHENTICATED');
        add(ClearMatchList());
      }
    });
  }

  @override
  MatchListState get initialState => MatchListUnauthenticated();

  @override
  Stream<MatchListState> mapEventToState(MatchListEvent event) async* {
    if (event is LoadMatchList) {
      yield* _mapLoadMatchListToState(event);
    } else if (event is ClearMatchList) {
      yield* _mapClearMatchListToState();
    }
  }

  Stream<MatchListState> _mapLoadMatchListToState(LoadMatchList event) async* {
    yield MatchListLoading();
    yield MatchListLoaded(event.matchList);
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
