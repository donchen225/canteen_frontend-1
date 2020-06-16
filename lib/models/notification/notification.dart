import 'package:canteen_frontend/models/notification/notification_entity.dart';
import 'package:canteen_frontend/models/user/user.dart';
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
  final String parent;
  final String parentId;
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
    @required this.parent,
    @required this.parentId,
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
        parent,
        parentId,
        data,
        count,
        read,
        createdOn,
        lastUpdated
      ];

  @override
  String toString() {
    return 'Notification { id: $id, from: $from, verb: $verb, target: $target, targetId: $targetId, object: $object, objectId: $objectId, parent: $parent, parentId: $parentId, data: $data, count: $count, read: $read, createdOn: $createdOn, lastUpdated: $lastUpdated }';
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
      parent: entity.parent,
      parentId: entity.parentId,
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
      parent: parent,
      parentId: parentId,
      data: data,
      count: count,
      read: read,
      createdOn: createdOn,
      lastUpdated: lastUpdated,
    );
  }
}

class DetailedNotification extends Notification {
  final User user;

  DetailedNotification({
    @required id,
    @required from,
    @required verb,
    @required target,
    @required targetId,
    @required object,
    @required objectId,
    @required parent,
    @required parentId,
    @required data,
    @required count,
    @required read,
    @required createdOn,
    @required lastUpdated,
    @required this.user,
  }) : super(
          id: id,
          from: from,
          verb: verb,
          target: target,
          targetId: targetId,
          object: object,
          objectId: objectId,
          parent: parent,
          parentId: parentId,
          data: data,
          count: count,
          read: read,
          createdOn: createdOn,
          lastUpdated: lastUpdated,
        );

  @override
  List<Object> get props => [
        id,
        from,
        verb,
        target,
        targetId,
        object,
        objectId,
        parent,
        parentId,
        data,
        count,
        read,
        createdOn,
        lastUpdated,
        user
      ];

  static DetailedNotification fromNotification(
    Notification notification,
    User user,
  ) {
    return DetailedNotification(
      id: notification.id,
      from: notification.from,
      verb: notification.verb,
      target: notification.target,
      targetId: notification.targetId,
      object: notification.object,
      objectId: notification.objectId,
      parent: notification.parent,
      parentId: notification.parentId,
      data: notification.data,
      count: notification.count,
      read: notification.read,
      createdOn: notification.createdOn,
      lastUpdated: notification.lastUpdated,
      user: user,
    );
  }
}
