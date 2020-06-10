import 'package:canteen_frontend/models/notification/notification_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Notification extends Equatable {
  final String id;
  final String type;
  final String data;
  final String from;
  final bool read;
  final DateTime createdOn;
  final DateTime lastUpdated;

  const Notification({
    @required this.id,
    @required this.type,
    @required this.data,
    @required this.from,
    @required this.read,
    @required this.createdOn,
    @required this.lastUpdated,
  });

  @override
  List<Object> get props =>
      [id, type, data, from, read, createdOn, lastUpdated];

  @override
  String toString() {
    return 'Notification { id: $id, type: $type, from: $from, data: $data createdOn: $createdOn, lastUpdated: $lastUpdated }';
  }

  static Notification fromEntity(NotificationEntity entity) {
    return Notification(
      id: entity.id,
      type: entity.type,
      data: entity.data,
      from: entity.from,
      read: entity.read,
      createdOn: entity.createdOn,
      lastUpdated: entity.lastUpdated,
    );
  }

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      type: type,
      from: from,
      data: data,
      read: read,
      createdOn: createdOn,
      lastUpdated: lastUpdated,
    );
  }
}
