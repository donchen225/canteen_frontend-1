import 'package:canteen_frontend/models/video_chat_date/video_chat_date_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class VideoChatDate extends Equatable {
  final String id;
  final String userId;
  final DateTime startTime;
  final int duration;
  final String timeZone;
  final DateTime lastUpdated;
  final int status;

  const VideoChatDate({
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

  static VideoChatDate fromEntity(VideoChatDateEntity entity) {
    return VideoChatDate(
      id: entity.id,
      userId: entity.userId,
      startTime: entity.startTime,
      duration: entity.duration,
      timeZone: entity.timeZone,
      lastUpdated: entity.lastUpdated,
      status: entity.status,
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
