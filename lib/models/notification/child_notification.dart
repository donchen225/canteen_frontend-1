import 'package:canteen_frontend/models/notification/child_notification_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ChildNotification extends Equatable {
  final String id;
  final String objectId;
  final String data;
  final String from;
  final DateTime createdOn;

  const ChildNotification({
    @required this.id,
    @required this.from,
    @required this.objectId,
    @required this.data,
    @required this.createdOn,
  });

  @override
  List<Object> get props => [id, from, objectId, data, createdOn];

  @override
  String toString() {
    return 'Notification { id: $id, from: $from, objectId: $objectId, data: $data createdOn: $createdOn }';
  }

  static ChildNotification fromEntity(ChildNotificationEntity entity) {
    return ChildNotification(
      id: entity.id,
      from: entity.from,
      objectId: entity.objectId,
      data: entity.data,
      createdOn: entity.createdOn,
    );
  }

  ChildNotificationEntity toEntity() {
    return ChildNotificationEntity(
      id: id,
      from: from,
      objectId: objectId,
      data: data,
      createdOn: createdOn,
    );
  }
}
