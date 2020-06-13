import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class NotificationEntity extends Equatable {
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

  const NotificationEntity({
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

  Map<String, Object> toJson() {
    return {
      'id': id,
      'from': from,
      'verb': verb,
      'target': target,
      'target_id': targetId,
      'object': object,
      'object_id': objectId,
      'data': data,
      'count': count,
      'read': read,
      'created_on': createdOn,
      'last_updated': lastUpdated,
    };
  }

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
    return 'NotificationEntity { id: $id, from: $from, verb: $verb, target: $target, targetId: $targetId, object: $object, objectId: $objectId, data: $data, count: $count, read: $read, createdOn: $createdOn, lastUpdated: $lastUpdated }';
  }

  static NotificationEntity fromJson(Map<String, Object> json) {
    return NotificationEntity(
      id: json['id'] as String,
      from: json['from'] as String,
      verb: json['verb'] as String,
      target: json['target'] as String,
      targetId: json['target_id'] as String,
      object: json['object'] as String,
      objectId: json['object_id'] as String,
      data: json['data'] as String,
      count: json['count'] as int,
      read: json['read'] as bool,
      createdOn: DateTime.parse(json['created_on']),
      lastUpdated: DateTime.parse(json['last_updated']),
    );
  }

  static NotificationEntity fromSnapshot(DocumentSnapshot snapshot) {
    return NotificationEntity(
      id: snapshot.documentID,
      from: snapshot.data['from'],
      verb: snapshot.data['verb'],
      target: snapshot.data['target'],
      targetId: snapshot.data['target_id'],
      object: snapshot.data['object'],
      objectId: snapshot.data['object_id'],
      data: snapshot.data['data'],
      count: snapshot.data['count'],
      read: snapshot.data['read'],
      createdOn: snapshot.data["created_on"].toDate(),
      lastUpdated: snapshot.data["last_updated"].toDate(),
    );
  }

  Map<String, Object> toDocument() {
    return {
      'verb': verb,
      'target': target,
      'target_id': targetId,
      'object': object,
      'object_id': objectId,
      'data': data,
      'count': count,
      'read': read,
      'created_on': createdOn,
      'last_updated': lastUpdated,
    };
  }
}
