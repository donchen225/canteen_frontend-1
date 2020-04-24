import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class VideoChatDateEntity extends Equatable {
  final String id;
  final String userId;
  final DateTime startTime;
  final int duration;
  final String timeZone;
  final DateTime lastUpdated;
  final int status;

  const VideoChatDateEntity({
    this.id,
    this.userId,
    this.startTime,
    this.duration,
    this.timeZone,
    this.lastUpdated,
    this.status,
  });

  @override
  List<Object> get props => [
        id,
        userId,
        startTime,
        duration,
        timeZone,
        lastUpdated,
        status,
      ];

  static VideoChatDateEntity fromSnapshot(DocumentSnapshot snap) {
    return VideoChatDateEntity(
      id: snap.documentID,
      userId: snap.data["user_id"],
      startTime: snap.data["start_time"],
      duration: snap.data["duration"],
      timeZone: snap.data["time_zone"],
      lastUpdated: snap.data["last_updated"],
      status: snap.data["status"],
    );
  }

  Map<String, Object> toDocument() {
    return {
      "user_id": userId,
      "start_time": startTime,
      "duration": duration,
      "time_zone": timeZone,
      "last_updated": lastUpdated,
      "status": status,
    };
  }
}
