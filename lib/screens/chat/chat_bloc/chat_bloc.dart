import 'dart:async';
import 'package:canteen_frontend/models/chat/chat.dart';
import 'package:canteen_frontend/models/chat/message.dart';
import 'package:meta/meta.dart';

import 'package:canteen_frontend/models/chat/chat_repository.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/chat/chat_bloc/chat_event.dart';
import 'package:canteen_frontend/screens/chat/chat_bloc/chat_state.dart';
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
      yield* _mapReceiveChatsEventToState(event);
    }

    if (event is AddChat) {
      yield* _mapAddChatToState(event);
    }
  }

  Stream<ChatState> _mapLoadChatsEventToState(LoadChats event) async* {
    try {
      chatsSubscription?.cancel();
      chatsSubscription = _chatRepository.getChats().listen((chats) {
        print('RECEIVED CHATS EVENT');
        add(ReceivedChats(chats));
      });
    } catch (exception) {
      print(exception.errorMessage());
      yield ErrorState(exception);
    }
  }

  Stream<ChatState> _mapReceiveChatsEventToState(ReceivedChats event) async* {
    final messageList = await Future.wait(event.chatList
        .map((chat) => _chatRepository
            .getMessage(chat.id, chat.lastUpdated)
            .catchError((w) => Future<Message>.value(null)))
        .toList());
    List<Chat> updatedChatList = [];

    for (int i = 0; i < event.chatList.length; i++) {
      Message message = messageList[i];

      if (message != null) {
        updatedChatList.add(event.chatList[i].addLastMessage(messageList[i]));
      } else {
        updatedChatList.add(event.chatList[i]);
      }
    }
    yield ChatListLoaded(updatedChatList);
  }

  Stream<ChatState> _mapAddChatToState(AddChat event) async* {
    _chatRepository.addChat(event.chat);
  }

  @override
  Future<void> close() {
    messagesSubscriptionMap.forEach((_, subscription) => subscription.cancel());
    return super.close();
  }
}
