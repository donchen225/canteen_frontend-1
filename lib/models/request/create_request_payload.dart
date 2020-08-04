// The payload for the addRequest onCall Cloud Function
class CreateRequestPayload {
  final String receiverId;
  final String referralId;
  final String comment;
  final String referralComment;
  final int index; // index of skill in array
  final String type; // "offer" or "request"
  final DateTime time;

  CreateRequestPayload({
    this.receiverId,
    this.referralId,
    this.comment,
    this.referralComment,
    this.index,
    this.type,
    this.time,
  });

  Map<String, Object> toJson() {
    return {
      'receiver_id': receiverId,
      'referral_id': referralId,
      'comment': comment,
      'referral_comment': referralComment,
      'index': index,
      'type': type,
      'time': time?.millisecondsSinceEpoch ?? null,
    };
  }
}
