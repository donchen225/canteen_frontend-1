import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class VideoChatRoomEntity extends Equatable {
  final String id;
  final String startUrl;
  final String joinUrl;
  final DateTime startTime;
  final int duration;
  final String timeZone;
  final DateTime createdOn;
  final int status;

  const VideoChatRoomEntity(
    this.id,
    this.startUrl,
    this.joinUrl,
    this.startTime,
    this.duration,
    this.timeZone,
    this.createdOn,
    this.status,
  );

  @override
  List<Object> get props => [
        id,
        startUrl,
        joinUrl,
        startTime,
        duration,
        timeZone,
        createdOn,
        status,
      ];

  static VideoChatRoomEntity fromSnapshot(DocumentSnapshot snap) {
    return VideoChatRoomEntity(
      snap.documentID,
      snap.data["start_url"],
      snap.data["join_url"],
      snap.data["start_time"],
      snap.data["duration"],
      snap.data["time_zone"],
      snap.data["created_on"],
      snap.data["status"],
    );
  }

  Map<String, Object> toDocument() {
    return {
      "start_url": startUrl,
      "join_url": joinUrl,
      "start_time": startTime,
      "duration": duration,
      "time_zone": timeZone,
      "created_on": createdOn,
      "status": status,
    };
  }
}
