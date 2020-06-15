import 'package:canteen_frontend/models/notification/notification_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Notification extends Equatable {
  final String id;
  final String from;
  final String verb;
  final String target;
  final String targetId;
  final String object;
  final String objectId;
  final String data;
  final int count;
  final bool read;
  final DateTime createdOn;
  final DateTime lastUpdated;

  const Notification({
    @required this.id,
    @required this.from,
    @required this.verb,
    @required this.target,
    @required this.targetId,
    @required this.object,
    @required this.objectId,
    @required this.data,
    @required this.count,
    @required this.read,
    @required this.createdOn,
    @required this.lastUpdated,
  });

  @override
  List<Object> get props => [
        id,
        from,
        verb,
        target,
        targetId,
        object,
        objectId,
        data,
        count,
        read,
        createdOn,
        lastUpdated
      ];

  @override
  String toString() {
    return 'Notification { id: $id, from: $from, verb: $verb, target: $target, targetId: $targetId, object: $object, objectId: $objectId, data: $data, count: $count, read: $read, createdOn: $createdOn, lastUpdated: $lastUpdated }';
  }

  static Notification fromEntity(NotificationEntity entity) {
    return Notification(
      id: entity.id,
      from: entity.from,
      verb: entity.verb,
      target: entity.target,
      targetId: entity.targetId,
      object: entity.object,
      objectId: entity.objectId,
      data: entity.data,
      read: entity.read,
      count: entity.count,
      createdOn: entity.createdOn,
      lastUpdated: entity.lastUpdated,
    );
  }

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      from: from,
      verb: verb,
      target: target,
      targetId: targetId,
      object: object,
      objectId: objectId,
      data: data,
      count: count,
      read: read,
      createdOn: createdOn,
      lastUpdated: lastUpdated,
    );
  }
}
