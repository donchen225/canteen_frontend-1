import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class UserGroupEntity extends Equatable {
  final String id;
  final String role;
  final DateTime joinedOn;

  const UserGroupEntity({
    @required this.id,
    @required this.role,
    @required this.joinedOn,
  });

  Map<String, Object> toJson() {
    return {
      'id': id,
      'role': role,
      'joined_on': joinedOn,
    };
  }

  @override
  List<Object> get props => [id, role, joinedOn];

  @override
  String toString() {
    return 'UserGroupEntity { id: $id, role: $role, joinedOn: $joinedOn }';
  }

  static UserGroupEntity fromJson(Map<String, Object> json) {
    return UserGroupEntity(
      id: json['id'] as String,
      role: json['role'] as String,
      joinedOn: DateTime.parse(json['joined_on']),
    );
  }

  static UserGroupEntity fromSnapshot(DocumentSnapshot snapshot) {
    return UserGroupEntity(
      id: snapshot.documentID,
      role: snapshot.data['role'],
      joinedOn: snapshot.data["joined_on"].toDate(),
    );
  }

  Map<String, Object> toDocument() {
    return {
      'id': id,
      'role': role,
      'joinedOn': joinedOn,
    };
  }
}
