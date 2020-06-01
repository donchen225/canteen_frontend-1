import 'package:canteen_frontend/models/group/user_group_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class UserGroup extends Equatable {
  final String id;
  final String groupId;
  final String role;
  final DateTime joinedOn;

  const UserGroup({
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
    return 'UserGroup { id: $id, groupId: $groupId, role: $role, joinedOn: $joinedOn }';
  }

  static UserGroup fromEntity(UserGroupEntity entity) {
    return UserGroup(
      id: entity.id,
      groupId: entity.groupId,
      role: entity.role,
      joinedOn: entity.joinedOn,
    );
  }

  UserGroupEntity toEntity() {
    return UserGroupEntity(
      id: id,
      groupId: groupId,
      role: role,
      joinedOn: joinedOn,
    );
  }
}
