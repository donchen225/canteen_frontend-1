import 'dart:async';
import 'package:canteen_frontend/models/chat/message.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:meta/meta.dart';

import 'package:canteen_frontend/models/chat/chat_repository.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/chat/bloc/chat_event.dart';
import 'package:canteen_frontend/screens/chat/bloc/chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;
  final UserRepository _userRepository;
  // final StorageRepository storageRepository;
  Map<String, StreamSubscription> messagesSubscriptionMap = Map();
  StreamSubscription chatsSubscription;
  String activeChatId;

  ChatBloc({
    @required chatRepository,
    @required userRepository,
  })  : assert(chatRepository != null),
        assert(userRepository != null),
        _chatRepository = chatRepository,
        _userRepository = userRepository;

  @override
  ChatState get initialState => InitialChatState();

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is LoadChats) {
      yield* _mapLoadChatsEventToState(event);
    }
    if (event is RegisterActiveChatEvent) {
      activeChatId = event.activeChatId;
    }
    if (event is ReceivedChats) {
      yield ChatListLoaded(event.chatList);
    }

    if (event is AddChat) {
      yield* _mapAddChatToState(event);
    }

    if (event is PageChangedEvent) {
      activeChatId = event.activeChat.id;
      yield PageChangedState(event.index, event.activeChat);
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
      print('dispatching received messages');
      yield FetchedMessagesState(event.messages, event.userId,
          isPrevious: false);
    }
    if (event is SendTextMessageEvent) {
      Message message = TextMessage(
        text: event.message,
        timestamp: DateTime.now().toUtc(),
        isSelf: true,
        senderId: _userRepository
            .currentUserId(), // TODO: get this from user preferene?
      );
      await _chatRepository.sendMessage(activeChatId, message);
    }

    if (event is ToggleEmojiKeyboardEvent) {
      yield ToggleEmojiKeyboardState(event.showEmojiKeyboard);
    }
  }

  Stream<ChatState> _mapLoadChatsEventToState(LoadChats event) async* {
    try {
      chatsSubscription?.cancel();
      chatsSubscription = _chatRepository
          .getChats()
          .listen((chats) => add(ReceivedChats(chats)));
    } catch (exception) {
      print(exception.errorMessage());
      yield ErrorState(exception);
    }
  }

  Stream<ChatState> _mapAddChatToState(AddChat event) async* {
    _chatRepository.addChat(event.chat);
  }

  Stream<ChatState> mapFetchMessagesEventToState(
      FetchMessagesEvent event) async* {
    try {
      yield FetchingMessageState();
      StreamSubscription messagesSubscription =
          messagesSubscriptionMap[event.chat.id];
      messagesSubscription?.cancel();
      messagesSubscription = _chatRepository.getMessages(event.chat.id).listen(
          (messages) => add(ReceivedMessagesEvent(
              messages,
              event.chat.userId.keys.firstWhere((id) =>
                  id !=
                  CachedSharedPreferences.getString(
                      PreferenceConstants.userId)))));

      messagesSubscriptionMap[event.chat.id] = messagesSubscription;
    } catch (exception) {
      print(exception.errorMessage());
      yield ErrorState(exception);
    }
  }

  Stream<ChatState> mapFetchPreviousMessagesEventToState(
      FetchPreviousMessagesEvent event) async* {
    try {
      final messages = await _chatRepository.getPreviousMessages(
          event.chat.id, event.lastMessage);
      yield FetchedMessagesState(
          messages,
          event.chat.userId.keys.firstWhere((id) =>
              id !=
              CachedSharedPreferences.getString(PreferenceConstants.userId)),
          isPrevious: true);
    } catch (exception) {
      print(exception.errorMessage());
      yield ErrorState(exception);
    }
  }

  Stream<ChatState> mapFetchConversationDetailsEventToState(
      FetchConversationDetailsEvent event) async* {
    print('fetching details for ${event.chat.id}');
    User user = await _userRepository.getUser(event.chat.id);
    yield FetchedContactDetailsState(
        user,
        event.chat.userId.keys.firstWhere((id) =>
            id !=
            CachedSharedPreferences.getString(PreferenceConstants.userId)));
    add(FetchMessagesEvent(event.chat));
  }

  @override
  Future<void> close() {
    messagesSubscriptionMap.forEach((_, subscription) => subscription.cancel());
    return super.close();
  }
}
