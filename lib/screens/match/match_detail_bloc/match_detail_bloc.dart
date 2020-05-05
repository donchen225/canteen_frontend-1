import 'dart:async';

import 'package:canteen_frontend/models/match/status.dart';
import 'package:canteen_frontend/models/video_chat_date/video_chat_repository.dart';
import 'package:canteen_frontend/screens/match/match_detail_bloc/match_detail_event.dart';
import 'package:canteen_frontend/screens/match/match_detail_bloc/match_detail_state.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class MatchDetailBloc extends Bloc<MatchDetailEvent, MatchDetailState> {
  final VideoChatRepository _videoChatRepository;
  Map<String, StreamSubscription> matchDetailsSubscriptionMap = Map();

  MatchDetailBloc({@required videoChatRepository})
      : assert(videoChatRepository != null),
        _videoChatRepository = videoChatRepository;

  MatchDetailState get initialState => MatchUninitialized();

  @override
  Stream<MatchDetailState> mapEventToState(MatchDetailEvent event) async* {
    if (event is LoadMatchDetails) {
      yield* _mapLoadMatchDetailsToState(event);
    } else if (event is SelectVideoChatDate) {
      yield* _mapSelectVideoChatDateToState(event);
    } else if (event is ViewVideoChatDates) {
      yield* _mapViewVideoChatDatesToState();
    }
  }

  Stream<MatchDetailState> _mapLoadMatchDetailsToState(
      LoadMatchDetails event) async* {
    try {
      final userId =
          CachedSharedPreferences.getString(PreferenceConstants.userId);
      final status = event.match.status;

      switch (status) {
        case MatchStatus.uninitialized:
          if (event.match.senderId == userId) {
            yield MatchTimeSelecting();
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

  // Stream<MatchDetailState> _mapReceivedVideoChatDetailsToState(
  //     ReceivedVideoChatDetails event) async* {
  //   if (event.dates.isEmpty) {
  //     yield MatchTimeSelecting();
  //   } else {
  //     // If partner proposed dates, show their dates
  //     yield MatchInitialized();
  //   }
  // }

  Stream<MatchDetailState> _mapViewVideoChatDatesToState() async* {
    yield MatchTimeSelecting();
  }

  Stream<MatchDetailState> _mapSelectVideoChatDateToState(
      SelectVideoChatDate event) async* {
    print('PROPOSING VIDEO CHAT DATES');
    print('MATCH ID: ${event.matchId}');
    print('VIDEO CHAT ID: ${event.videoChatId}');
    // await _videoChatRepository.addVideoChatDates(
    //     event.dates, event.matchId, event.videoChatId);
    yield MatchPaying(date: event.date);
  }
}
