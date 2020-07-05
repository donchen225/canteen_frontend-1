import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SendRequestEvent extends Equatable {
  const SendRequestEvent();

  @override
  List<Object> get props => [];
}

class SendRequest extends SendRequestEvent {
  final String receiverId;
  final String comment;
  final int index;
  final String type;
  final DateTime time;

  const SendRequest(
      {this.receiverId, this.comment, this.index, this.type, this.time});

  @override
  List<Object> get props => [receiverId, comment, index, type, time];

  @override
  String toString() =>
      'SendRequest { receiverId: $receiverId, comment: $comment, index: $index, type: $type, time: $time }';
}
