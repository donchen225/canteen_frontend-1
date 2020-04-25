import 'dart:async';

import 'package:canteen_frontend/models/video_chat_date/video_chat_repository.dart';
import 'package:canteen_frontend/screens/video_chat_details/bloc/video_chat_details_event.dart';
import 'package:canteen_frontend/screens/video_chat_details/bloc/video_chat_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class VideoChatDetailsBloc
    extends Bloc<VideoChatDetailsEvent, VideoChatDetailsState> {
  final VideoChatRepository _videoChatRepository;
  Map<String, StreamSubscription> videoChatDetailsSubscriptionMap = Map();

  VideoChatDetailsBloc({@required videoChatRepository})
      : assert(videoChatRepository != null),
        _videoChatRepository = videoChatRepository;

  VideoChatDetailsState get initialState => VideoChatDetailsUninitialized();

  @override
  Stream<VideoChatDetailsState> mapEventToState(
      VideoChatDetailsEvent event) async* {
    if (event is LoadVideoChatDetails) {
      yield* _mapLoadVideoChatDetailsToState(event);
    } else if (event is ReceivedVideoChatDetails) {
      yield* _mapReceivedVideoChatDetailsToState(event);
    } else if (event is ProposeVideoChatDates) {
      yield* _mapProposeVideoChatDatesToState(event);
    }
  }

  Stream<VideoChatDetailsState> _mapLoadVideoChatDetailsToState(
      LoadVideoChatDetails event) async* {
    try {
      yield VideoChatDetailsLoading();
      StreamSubscription videoChatDetailsSubscription =
          videoChatDetailsSubscriptionMap[event.matchId];
      videoChatDetailsSubscription?.cancel();
      videoChatDetailsSubscription = _videoChatRepository
          .getVideoChatDates(event.matchId, event.videoChatId)
          .listen((videoChatDetails) {
        print('LISTENING TO VIDEO CHAT DETAILS');
        print(videoChatDetails);
        add(ReceivedVideoChatDetails(videoChatDetails));
      });
      videoChatDetailsSubscriptionMap[event.matchId] =
          videoChatDetailsSubscription;
    } catch (exception) {
      print('VIDEO CHAT DETAILS ERROR: $exception');
      yield VideoChatDetailsUninitialized();
    }
  }

  Stream<VideoChatDetailsState> _mapReceivedVideoChatDetailsToState(
      ReceivedVideoChatDetails event) async* {
    if (event.dates.isEmpty) {
      yield VideoChatDetailsUninitialized();
    } else {
      // If partner proposed dates, show their dates
      yield VideoChatDetailsProposing();
    }
  }

  Stream<VideoChatDetailsState> _mapProposeVideoChatDatesToState(
      ProposeVideoChatDates event) async* {
    print('PROPOSING VIDEO CHAT DATES');
    print('MATCH ID: ${event.matchId}');
    print('VIDEO CHAT ID: ${event.videoChatId}');
    await _videoChatRepository.addVideoChatDates(
        event.dates, event.matchId, event.videoChatId);
    yield VideoChatDetailsProposing();
  }
}
