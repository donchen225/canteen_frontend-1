import 'package:canteen_frontend/models/chat/chat.dart';
import 'package:canteen_frontend/models/chat/message.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class AddChat extends ChatEvent {
  final Chat chat;

  const AddChat(this.chat);

  @override
  String toString() => 'AddChat { chat: $chat }';
}

class LoadChats extends ChatEvent {
  @override
  String toString() => 'LoadChats';
}

class ReceivedChats extends ChatEvent {
  final List<Chat> chatList;

  const ReceivedChats(this.chatList);

  @override
  String toString() => 'ReceivedChats { chatList: $chatList }';
}

//triggered to get details of currently open conversation
class FetchConversationDetailsEvent extends ChatEvent {
  final Chat chat;

  const FetchConversationDetailsEvent(this.chat);

  @override
  String toString() => 'FetchConversationDetailsEvent';
}

//triggered to fetch messages of chat, this will also keep a subscription for new messages
class FetchMessagesEvent extends ChatEvent {
  final Chat chat;

  const FetchMessagesEvent(this.chat);

  @override
  String toString() => 'FetchMessagesEvent';
}

//triggered to fetch messages of chat
class FetchPreviousMessagesEvent extends ChatEvent {
  final Chat chat;
  final Message lastMessage;

  const FetchPreviousMessagesEvent(this.chat, this.lastMessage);

  @override
  String toString() => 'FetchPreviousMessagesEvent';
}

//triggered when messages stream has new data
class ReceivedMessagesEvent extends ChatEvent {
  final List<Message> messages;
  final String userId;

  const ReceivedMessagesEvent(this.messages, this.userId);

  @override
  String toString() => 'ReceivedMessagesEvent';
}

//triggered to send new text message
class SendTextMessageEvent extends ChatEvent {
  final String message;

  const SendTextMessageEvent(this.message);

  @override
  String toString() => 'SendTextMessageEvent { message: $message }';
}

//triggered on page change
class PageChangedEvent extends ChatEvent {
  final int index;
  final Chat activeChat;

  const PageChangedEvent(this.index, this.activeChat);

  @override
  String toString() =>
      'PageChangedEvent { index: $index, activeChat: $activeChat }';
}

class RegisterActiveChatEvent extends ChatEvent {
  final String activeChatId;

  const RegisterActiveChatEvent(this.activeChatId);

  @override
  String toString() =>
      'RegisterActiveChatEvent { activeChatId : $activeChatId }';
}

// hide/show emojikeyboard
class ToggleEmojiKeyboardEvent extends ChatEvent {
  final bool showEmojiKeyboard;

  ToggleEmojiKeyboardEvent(this.showEmojiKeyboard);

  @override
  String toString() => 'ToggleEmojiKeyboardEvent';
}
