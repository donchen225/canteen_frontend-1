import 'package:canteen_frontend/models/chat/chat.dart';
import 'package:canteen_frontend/models/chat/message.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class InitialChatState extends ChatState {}

class ChatListLoaded extends ChatState {
  final List<Chat> chatList;

  const ChatListLoaded(this.chatList);

  @override
  List<Object> get props => [chatList];

  @override
  String toString() => 'ChatListLoaded { chatList: $chatList }';
}

class FetchingMessageState extends ChatState {
  @override
  String toString() => 'FetchingMessageState';
}

class FetchedMessagesState extends ChatState {
  final List<Message> messages;
  final String userId;
  final isPrevious;
  FetchedMessagesState(this.messages, this.userId, {this.isPrevious});

  @override
  List<Object> get props => [messages, userId, isPrevious];

  @override
  String toString() =>
      'FetchedMessagesState {messages: $messages, userId: $userId, isPrevious: $isPrevious}';
}

class ErrorState extends ChatState {
  final Exception exception;

  ErrorState(this.exception);

  @override
  String toString() => 'ErrorState';
}

class FetchedContactDetailsState extends ChatState {
  final User user;
  final String username;

  const FetchedContactDetailsState(this.user, this.username);

  @override
  String toString() => 'FetchedContactDetailsState';
}

class PageChangedState extends ChatState {
  final int index;
  final Chat activeChat;

  const PageChangedState(this.index, this.activeChat);

  @override
  String toString() => 'PageChangedState';
}

class ToggleEmojiKeyboardState extends ChatState {
  final bool showEmojiKeyboard;

  const ToggleEmojiKeyboardState(this.showEmojiKeyboard);

  @override
  String toString() => 'ToggleEmojiKeyboardState';
}
