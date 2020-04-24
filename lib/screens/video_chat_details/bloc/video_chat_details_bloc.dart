import 'package:canteen_frontend/screens/video_chat_details/bloc/video_chat_details_event.dart';
import 'package:canteen_frontend/screens/video_chat_details/bloc/video_chat_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VideoChatDetailsBloc
    extends Bloc<VideoChatDetailsEvent, VideoChatDetailsState> {
  VideoChatDetailsBloc();

  VideoChatDetailsState get initialState => VideoChatDetailsUninitialized();

  @override
  Stream<VideoChatDetailsState> mapEventToState(
      VideoChatDetailsEvent event) async* {
    if (event is CheckVideoChatStatus) {
      yield* _mapCheckVideoChatStatusToState();
    } else if (event is ProposeVideoChatDetails) {
      yield* _mapProposeVideoChatDetailsToState();
    }
  }

  Stream<VideoChatDetailsState> _mapCheckVideoChatStatusToState() async* {
    try {
      final videoChat = 1;
      if (videoChat != null) {}
    } catch (e) {
      print('VIDEO CHAT DETAILS ERROR: $e');
      yield VideoChatDetailsUninitialized();
    }
    yield VideoChatDetailsProposing();
  }

  Stream<VideoChatDetailsState> _mapProposeVideoChatDetailsToState() async* {
    yield VideoChatDetailsProposing();
  }
}
