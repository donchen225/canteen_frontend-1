import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class UserGroupEntity extends Equatable {
  final String id;
  final String groupId;
  final String role;
  final DateTime joinedOn;

  const UserGroupEntity({
    @required this.id,
    @required this.groupId,
    @required this.role,
    @required this.joinedOn,
  });

  Map<String, Object> toJson() {
    return {
      'id': id,
      'group_id': groupId,
      'role': role,
      'joined_on': joinedOn,
    };
  }

  @override
  List<Object> get props => [id, groupId, role, joinedOn];

  @override
  String toString() {
    return 'UserGroupEntity { id: $id, groupId: $groupId, role: $role, joinedOn: $joinedOn }';
  }

  static UserGroupEntity fromJson(Map<String, Object> json) {
    return UserGroupEntity(
      id: json['id'] as String,
      groupId: json['group_id'] as String,
      role: json['role'] as String,
      joinedOn: DateTime.parse(json['joined_on']),
    );
  }

  static UserGroupEntity fromSnapshot(DocumentSnapshot snapshot) {
    return UserGroupEntity(
      id: snapshot.documentID,
      groupId: snapshot.data['group_id'],
      role: snapshot.data['role'],
      joinedOn: snapshot.data["joined_on"].toDate(),
    );
  }

  Map<String, Object> toDocument() {
    return {
      'id': id,
      'group_id': groupId,
      'role': role,
      'joinedOn': joinedOn,
    };
  }
}
