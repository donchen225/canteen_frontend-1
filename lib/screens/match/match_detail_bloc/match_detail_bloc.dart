import 'dart:async';

import 'package:canteen_frontend/models/video_chat_date/video_chat_repository.dart';
import 'package:canteen_frontend/screens/match/match_detail_bloc/match_detail_event.dart';
import 'package:canteen_frontend/screens/match/match_detail_bloc/match_detail_state.dart';
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
    } else if (event is ReceivedVideoChatDetails) {
      yield* _mapReceivedVideoChatDetailsToState(event);
    } else if (event is SelectVideoChatDate) {
      yield* _mapSelectVideoChatDateToState(event);
    } else if (event is ViewVideoChatDates) {
      yield* _mapViewVideoChatDatesToState();
    }
  }

  Stream<MatchDetailState> _mapLoadMatchDetailsToState(
      LoadMatchDetails event) async* {
    try {
      yield MatchLoading();
      StreamSubscription videoChatDetailsSubscription =
          matchDetailsSubscriptionMap[event.matchId];
      videoChatDetailsSubscription?.cancel();
      videoChatDetailsSubscription = _videoChatRepository
          .getVideoChatDates(event.matchId, event.videoChatId)
          .listen((videoChatDetails) {
        print('LISTENING TO VIDEO CHAT DETAILS');
        print(videoChatDetails);
        add(ReceivedVideoChatDetails(videoChatDetails));
      });
      matchDetailsSubscriptionMap[event.matchId] = videoChatDetailsSubscription;
    } catch (exception) {
      print('VIDEO CHAT DETAILS ERROR: $exception');
      yield MatchUninitialized();
    }
  }

  Stream<MatchDetailState> _mapReceivedVideoChatDetailsToState(
      ReceivedVideoChatDetails event) async* {
    if (event.dates.isEmpty) {
      yield MatchUninitialized();
    } else {
      // If partner proposed dates, show their dates
      yield MatchInitialized();
    }
  }

  Stream<MatchDetailState> _mapViewVideoChatDatesToState() async* {
    yield MatchUninitialized();
  }

  Stream<MatchDetailState> _mapSelectVideoChatDateToState(
      SelectVideoChatDate event) async* {
    print('PROPOSING VIDEO CHAT DATES');
    print('MATCH ID: ${event.matchId}');
    print('VIDEO CHAT ID: ${event.videoChatId}');
    // await _videoChatRepository.addVideoChatDates(
    //     event.dates, event.matchId, event.videoChatId);
    yield MatchUnpaid(date: event.date);
  }
}
