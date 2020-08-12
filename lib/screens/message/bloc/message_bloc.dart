import 'dart:async';
import 'package:canteen_frontend/models/message/message.dart';
import 'package:canteen_frontend/models/match/match_repository.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/message/bloc/message_event.dart';
import 'package:canteen_frontend/screens/message/bloc/message_state.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:meta/meta.dart';

import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MatchRepository _matchRepository;
  final UserRepository _userRepository;
  Map<String, StreamSubscription> messagesSubscriptionMap = Map();
  String activeChatId;

  MessageBloc({
    @required matchRepository,
    @required userRepository,
  })  : assert(matchRepository != null),
        assert(userRepository != null),
        _matchRepository = matchRepository,
        _userRepository = userRepository;

  @override
  MessageState get initialState => FetchingMessagesState();

  @override
  Stream<MessageState> mapEventToState(MessageEvent event) async* {
    if (event is RegisterActiveChatEvent) {
      activeChatId = event.activeChatId;
    }

    if (event is FetchConversationDetailsEvent) {
      yield* mapFetchConversationDetailsEventToState(event);
    }
    if (event is FetchMessagesEvent) {
      yield* mapFetchMessagesEventToState(event);
    }
    if (event is FetchPreviousMessagesEvent) {
      yield* mapFetchPreviousMessagesEventToState(event);
    }
    if (event is ReceivedMessagesEvent) {
      yield FetchedMessagesState(event.messages, event.userId,
          isPrevious: false);
    }
    if (event is SendTextMessageEvent) {
      Message message = TextMessage(
        text: event.message,
        timestamp: DateTime.now().toUtc(),
        isSelf: true,
        senderId: CachedSharedPreferences.getString(PreferenceConstants.userId),
      );
      await _matchRepository.sendMessage(activeChatId, message);
    }

    if (event is ToggleEmojiKeyboardEvent) {
      yield ToggleEmojiKeyboardState(event.showEmojiKeyboard);
    }
  }

  Stream<MessageState> mapFetchMessagesEventToState(
      FetchMessagesEvent event) async* {
    try {
      yield FetchingMessagesState();
      StreamSubscription messagesSubscription =
          messagesSubscriptionMap[event.match.id];
      messagesSubscription?.cancel();
      messagesSubscription = _matchRepository
          .getMessages(event.match.id)
          .listen((messages) => add(ReceivedMessagesEvent(
              messages,
              event.match.userId.firstWhere((id) =>
                  id !=
                  CachedSharedPreferences.getString(
                      PreferenceConstants.userId)))));

      messagesSubscriptionMap[event.match.id] = messagesSubscription;
    } catch (exception) {
      print('Error fetching messages: ${exception.errorMessage()}');
      yield ErrorState(exception);
    }
  }

  Stream<MessageState> mapFetchPreviousMessagesEventToState(
      FetchPreviousMessagesEvent event) async* {
    try {
      final messages = await _matchRepository.getPreviousMessages(
          event.match.id, event.lastMessage);
      yield FetchedMessagesState(
          messages,
          event.match.userId.firstWhere((id) =>
              id !=
              CachedSharedPreferences.getString(PreferenceConstants.userId)),
          isPrevious: true);
    } catch (exception) {
      print('Error fetching messages: ${exception.errorMessage()}');
      yield ErrorState(exception);
    }
  }

  Stream<MessageState> mapFetchConversationDetailsEventToState(
      FetchConversationDetailsEvent event) async* {
    final userId = event.match.userId.firstWhere((id) =>
        id != CachedSharedPreferences.getString(PreferenceConstants.userId));
    User user = await _userRepository.getUser(userId);
    yield FetchedContactDetailsState(user, userId);
    add(FetchMessagesEvent(event.match));
  }

  @override
  Future<void> close() {
    messagesSubscriptionMap.forEach((_, subscription) => subscription.cancel());
    return super.close();
  }
}
