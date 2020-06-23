import 'dart:async';

import 'package:canteen_frontend/models/match/match.dart';
import 'package:canteen_frontend/models/match/match_repository.dart';
import 'package:canteen_frontend/models/match/status.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/match/match_detail_bloc/match_detail_event.dart';
import 'package:canteen_frontend/screens/match/match_detail_bloc/match_detail_state.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class MatchDetailBloc extends Bloc<MatchDetailEvent, MatchDetailState> {
  final MatchRepository _matchRepository;
  final UserRepository _userRepository;
  Map<String, StreamSubscription> matchDetailsSubscriptionMap = Map();

  MatchDetailBloc({@required matchRepository, @required userRepository})
      : assert(userRepository != null),
        assert(matchRepository != null),
        _userRepository = userRepository,
        _matchRepository = matchRepository;

  MatchDetailState get initialState => MatchUninitialized();

  @override
  Stream<MatchDetailState> mapEventToState(MatchDetailEvent event) async* {
    if (event is LoadMatch) {
      yield* _mapLoadMatchDetailsToState(event);
    } else if (event is LoadMatchFromId) {
      yield* _mapLoadMatchFromIdToState(event);
    } else if (event is SelectVideoChatDate) {
      yield* _mapSelectVideoChatDateToState(event);
    } else if (event is SelectEvent) {
      yield* _mapSelectEventToState(event);
    } else if (event is SelectPayment) {
      yield* _mapSelectPaymentToState(event);
    } else if (event is ConfirmPayment) {
      yield* _mapConfirmPaymentToState(event);
    }
  }

  Stream<MatchDetailState> _mapLoadMatchDetailsToState(LoadMatch event) async* {
    try {
      final userId =
          CachedSharedPreferences.getString(PreferenceConstants.userId);
      final status = event.match.status;

      switch (status) {
        case MatchStatus.uninitialized:
          if (event.match.senderId == userId) {
            yield MatchEventSelecting();
          } else {
            yield MatchWaiting();
          }
          break;
        case MatchStatus.paid:
          yield MatchInitialized();
          break;
        case MatchStatus.completed:
          yield MatchCompleted();
          break;
      }
    } catch (exception) {
      print('VIDEO CHAT DETAILS ERROR: $exception');
      yield MatchError();
    }
  }

  Stream<MatchDetailState> _mapLoadMatchFromIdToState(
      LoadMatchFromId event) async* {
    yield MatchLoading();
    try {
      final match = await _matchRepository.getMatch(event.matchId);

      final userList = await Future.wait(match.userId.map((id) async {
        var u = await _userRepository.getUser(id);
        return u;
      }));

      final detailedMatch = DetailedMatch.fromMatch(match, userList);

      yield MatchLoaded(match: detailedMatch);
    } catch (exception) {
      print('ERROR: $exception');
      yield MatchError();
    }
  }

  // Stream<MatchDetailState> _mapReceivedVideoChatDetailsToState(
  //     ReceivedVideoChatDetails event) async* {
  //   if (event.dates.isEmpty) {
  //     yield MatchTimeSelecting();
  //   } else {
  //     // If partner proposed dates, show their dates
  //     yield MatchInitialized();
  //   }
  // }

  Stream<MatchDetailState> _mapSelectEventToState(SelectEvent event) async* {
    yield MatchTimeSelecting(event.skill);
  }

  Stream<MatchDetailState> _mapSelectVideoChatDateToState(
      SelectVideoChatDate event) async* {
    print('PROPOSING VIDEO CHAT DATES');
    print('MATCH ID: ${event.matchId}');
    print('VIDEO CHAT ID: ${event.videoChatId}');

    yield MatchPaying(skill: event.skill, date: event.date);
  }

  Stream<MatchDetailState> _mapSelectPaymentToState(
      SelectPayment event) async* {
    yield MatchPaymentConfirming(skill: event.skill);
  }

  Stream<MatchDetailState> _mapConfirmPaymentToState(
      ConfirmPayment event) async* {
    yield MatchLoading();
    await _matchRepository.confirmPayment(event.match);
    yield MatchInitialized();
  }
}
