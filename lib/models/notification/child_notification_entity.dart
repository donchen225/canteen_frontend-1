import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ChildNotificationEntity extends Equatable {
  final String id;
  final String objectId;
  final String data;
  final String from;
  final DateTime createdOn;

  const ChildNotificationEntity({
    @required this.id,
    @required this.from,
    @required this.objectId,
    @required this.data,
    @required this.createdOn,
  });

  Map<String, Object> toJson() {
    return {
      'id': id,
      'from': from,
      'object_id': objectId,
      'data': data,
      'created_on': createdOn,
    };
  }

  @override
  List<Object> get props => [id, objectId, data, from, createdOn];

  @override
  String toString() {
    return 'NotificationEntity { id: $id, from: $from, objectId: $objectId, data: $data createdOn: $createdOn }';
  }

  static ChildNotificationEntity fromJson(Map<String, Object> json) {
    return ChildNotificationEntity(
      id: json['id'] as String,
      from: json['from'] as String,
      objectId: json['object_id'] as String,
      data: json['data'] as String,
      createdOn: DateTime.parse(json['created_on']),
    );
  }

  static ChildNotificationEntity fromSnapshot(DocumentSnapshot snapshot) {
    return ChildNotificationEntity(
      id: snapshot.documentID,
      from: snapshot.data['from'],
      objectId: snapshot.data['object_id'],
      data: snapshot.data['data'],
      createdOn: snapshot.data["created_on"].toDate(),
    );
  }

  Map<String, Object> toDocument() {
    return {
      'from': from,
      'object_id': objectId,
      'data': data,
      'created_on': createdOn,
    };
  }
}
