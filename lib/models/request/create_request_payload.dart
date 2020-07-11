// The payload for the addRequest onCall Cloud Function
class CreateRequestPayload {
  final String receiverId;
  final String comment;
  final int index; // index of skill in array
  final String type; // "offer" or "request"
  final DateTime time;

  CreateRequestPayload({
    this.receiverId,
    this.comment,
    this.index,
    this.type,
    this.time,
  });

  Map<String, Object> toJson() {
    return {
      'receiver_id': receiverId,
      'comment': comment,
      'index': index,
      'type': type,
      'time': time?.millisecondsSinceEpoch ?? null,
    };
  }
}
