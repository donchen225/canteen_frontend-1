import 'package:canteen_frontend/models/match/match.dart';
import 'package:canteen_frontend/models/message/message.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

//triggered to get details of currently open conversation
class FetchConversationDetailsEvent extends MessageEvent {
  final Match match;

  const FetchConversationDetailsEvent(this.match);

  @override
  String toString() => 'FetchConversationDetailsEvent';
}

//triggered to fetch messages of chat, this will also keep a subscription for new messages
class FetchMessagesEvent extends MessageEvent {
  final Match match;

  const FetchMessagesEvent(this.match);

  @override
  String toString() => 'FetchMessagesEvent';
}

//triggered to fetch messages of chat
class FetchPreviousMessagesEvent extends MessageEvent {
  final Match match;
  final Message lastMessage;

  const FetchPreviousMessagesEvent(this.match, this.lastMessage);

  @override
  String toString() => 'FetchPreviousMessagesEvent';
}

//triggered when messages stream has new data
class ReceivedMessagesEvent extends MessageEvent {
  final List<Message> messages;
  final String userId;

  const ReceivedMessagesEvent(this.messages, this.userId);

  @override
  String toString() => 'ReceivedMessagesEvent';
}

//triggered to send new text message
class SendTextMessageEvent extends MessageEvent {
  final String message;

  const SendTextMessageEvent(this.message);

  @override
  String toString() => 'SendTextMessageEvent { message: $message }';
}

//triggered on page change
class PageChangedEvent extends MessageEvent {
  final int index;
  final Match activeMatch;

  const PageChangedEvent(this.index, this.activeMatch);

  @override
  String toString() =>
      'PageChangedEvent { index: $index, activeMatch: $activeMatch }';
}

class RegisterActiveChatEvent extends MessageEvent {
  final String activeChatId;

  const RegisterActiveChatEvent(this.activeChatId);

  @override
  String toString() =>
      'RegisterActiveChatEvent { activeChatId : $activeChatId }';
}

// hide/show emojikeyboard
class ToggleEmojiKeyboardEvent extends MessageEvent {
  final bool showEmojiKeyboard;

  ToggleEmojiKeyboardEvent(this.showEmojiKeyboard);

  @override
  String toString() => 'ToggleEmojiKeyboardEvent';
}
