import 'package:canteen_frontend/models/chat/chat.dart';
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

class RegisterActiveChatEvent extends ChatEvent {
  final String activeChatId;

  const RegisterActiveChatEvent(this.activeChatId);

  @override
  String toString() =>
      'RegisterActiveChatEvent { activeChatId : $activeChatId }';
}
