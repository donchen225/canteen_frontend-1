import 'package:canteen_frontend/models/chat/chat.dart';
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

class ErrorState extends ChatState {
  final Exception exception;

  ErrorState(this.exception);

  @override
  String toString() => 'ErrorState';
}
