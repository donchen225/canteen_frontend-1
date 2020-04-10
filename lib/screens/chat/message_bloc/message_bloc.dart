import 'dart:async';
import 'package:canteen_frontend/models/chat/message.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/chat/message_bloc/message_event.dart';
import 'package:canteen_frontend/screens/chat/message_bloc/message_state.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:meta/meta.dart';

import 'package:canteen_frontend/models/chat/chat_repository.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final ChatRepository _chatRepository;
  final UserRepository _userRepository;
  Map<String, StreamSubscription> messagesSubscriptionMap = Map();
  StreamSubscription chatsSubscription;
  String activeChatId;

  MessageBloc({
    @required chatRepository,
    @required userRepository,
  })  : assert(chatRepository != null),
        assert(userRepository != null),
        _chatRepository = chatRepository,
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
      await _chatRepository.sendMessage(activeChatId, message);
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
          messagesSubscriptionMap[event.chat.id];
      messagesSubscription?.cancel();
      messagesSubscription = _chatRepository.getMessages(event.chat.id).listen(
          (messages) => add(ReceivedMessagesEvent(
              messages,
              event.chat.userId.firstWhere((id) =>
                  id !=
                  CachedSharedPreferences.getString(
                      PreferenceConstants.userId)))));

      messagesSubscriptionMap[event.chat.id] = messagesSubscription;
    } catch (exception) {
      print(exception.errorMessage());
      yield ErrorState(exception);
    }
  }

  Stream<MessageState> mapFetchPreviousMessagesEventToState(
      FetchPreviousMessagesEvent event) async* {
    try {
      final messages = await _chatRepository.getPreviousMessages(
          event.chat.id, event.lastMessage);
      yield FetchedMessagesState(
          messages,
          event.chat.userId.firstWhere((id) =>
              id !=
              CachedSharedPreferences.getString(PreferenceConstants.userId)),
          isPrevious: true);
    } catch (exception) {
      print(exception.errorMessage());
      yield ErrorState(exception);
    }
  }

  Stream<MessageState> mapFetchConversationDetailsEventToState(
      FetchConversationDetailsEvent event) async* {
    print('fetching details for ${event.chat.id}');
    final userId = event.chat.userId.firstWhere((id) =>
        id != CachedSharedPreferences.getString(PreferenceConstants.userId));
    User user = await _userRepository.getUser(userId);
    yield FetchedContactDetailsState(user, userId);
    add(FetchMessagesEvent(event.chat));
  }

  @override
  Future<void> close() {
    messagesSubscriptionMap.forEach((_, subscription) => subscription.cancel());
    return super.close();
  }
}
