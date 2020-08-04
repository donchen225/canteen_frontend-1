import 'package:equatable/equatable.dart';

abstract class SendRequestEvent extends Equatable {
  const SendRequestEvent();

  @override
  List<Object> get props => [];
}

class SendRequest extends SendRequestEvent {
  final String receiverId;
  final String referralId;
  final String comment;
  final String referralComment;
  final int index;
  final String type;
  final DateTime time;

  const SendRequest(
      {this.receiverId,
      this.referralId,
      this.comment,
      this.referralComment,
      this.index,
      this.type,
      this.time});

  @override
  List<Object> get props =>
      [receiverId, referralId, comment, referralComment, index, type, time];

  @override
  String toString() =>
      'SendRequest { receiverId: $receiverId, referralId: $referralId, comment: $comment, referralComment: $referralComment, index: $index, type: $type, time: $time }';
}
