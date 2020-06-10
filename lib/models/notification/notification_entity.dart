import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String type;
  final String data;
  final String from;
  final bool read;
  final DateTime createdOn;
  final DateTime lastUpdated;

  const NotificationEntity({
    @required this.id,
    @required this.type,
    @required this.data,
    @required this.from,
    @required this.read,
    @required this.createdOn,
    @required this.lastUpdated,
  });

  Map<String, Object> toJson() {
    return {
      'id': id,
      'type': type,
      'data': data,
      'from': from,
      'read': read,
      'created_on': createdOn,
      'last_updated': lastUpdated,
    };
  }

  @override
  List<Object> get props =>
      [id, type, data, from, read, createdOn, lastUpdated];

  @override
  String toString() {
    return 'NotificationEntity { id: $id, type: $type, from: $from, data: $data createdOn: $createdOn, lastUpdated: $lastUpdated }';
  }

  static NotificationEntity fromJson(Map<String, Object> json) {
    return NotificationEntity(
      id: json['id'] as String,
      from: json['from'] as String,
      type: json['type'] as String,
      data: json['data'] as String,
      read: json['read'] as bool,
      createdOn: DateTime.parse(json['created_on']),
      lastUpdated: DateTime.parse(json['last_updated']),
    );
  }

  static NotificationEntity fromSnapshot(DocumentSnapshot snapshot) {
    return NotificationEntity(
      id: snapshot.documentID,
      type: snapshot.data['type'],
      from: snapshot.data['from'],
      data: snapshot.data['data'],
      read: snapshot.data['read'],
      createdOn: snapshot.data["created_on"].toDate(),
      lastUpdated: snapshot.data["last_updated"].toDate(),
    );
  }

  Map<String, Object> toDocument() {
    return {
      'type': type,
      'data': data,
      'from': from,
      'read': read,
      'created_on': createdOn,
      'last_updated': lastUpdated,
    };
  }
}
