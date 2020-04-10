import 'package:canteen_frontend/models/chat/chat.dart';
import 'package:canteen_frontend/models/chat/message.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object> get props => [];
}

class FetchingMessagesState extends MessageState {
  @override
  String toString() => 'FetchingMessagesState';
}

class FetchedMessagesState extends MessageState {
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

class ErrorState extends MessageState {
  final Exception exception;

  ErrorState(this.exception);

  @override
  String toString() => 'ErrorState';
}

class FetchedContactDetailsState extends MessageState {
  final User user;
  final String username;

  const FetchedContactDetailsState(this.user, this.username);

  @override
  String toString() => 'FetchedContactDetailsState';
}

class ToggleEmojiKeyboardState extends MessageState {
  final bool showEmojiKeyboard;

  const ToggleEmojiKeyboardState(this.showEmojiKeyboard);

  @override
  String toString() => 'ToggleEmojiKeyboardState';
}
