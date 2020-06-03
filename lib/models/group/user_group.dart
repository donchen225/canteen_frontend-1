import 'package:canteen_frontend/models/group/user_group_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class UserGroup extends Equatable {
  final String id;
  final String role;
  final DateTime joinedOn;

  const UserGroup({
    @required this.id,
    @required this.role,
    @required this.joinedOn,
  });

  @override
  List<Object> get props => [id, role, joinedOn];

  @override
  String toString() {
    return 'UserGroup { id: $id, role: $role, joinedOn: $joinedOn }';
  }

  static UserGroup fromEntity(UserGroupEntity entity) {
    return UserGroup(
      id: entity.id,
      role: entity.role,
      joinedOn: entity.joinedOn,
    );
  }

  UserGroupEntity toEntity() {
    return UserGroupEntity(
      id: id,
      role: role,
      joinedOn: joinedOn,
    );
  }
}
