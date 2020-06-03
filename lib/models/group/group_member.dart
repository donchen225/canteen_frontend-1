import 'package:canteen_frontend/models/group/group_member_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class GroupMember extends Equatable {
  final String id;
  final String name;
  final String title;
  final String photoUrl;
  final DateTime joinedOn;

  const GroupMember({
    @required this.id,
    @required this.name,
    @required this.title,
    @required this.photoUrl,
    @required this.joinedOn,
  });

  @override
  List<Object> get props => [id, name, title, photoUrl, joinedOn];

  @override
  String toString() {
    return 'GroupMember { id: $id, name: $name, title: $title, photoUrl: $photoUrl, joinedOn: $joinedOn }';
  }

  static GroupMember fromJson(Map<String, Object> json) {
    return GroupMember(
      id: json['id'] as String,
      name: json['display_name'] as String,
      title: json['title'] as String,
      photoUrl: json['photo_url'] as String,
      joinedOn: DateTime.parse(json['joined_on']),
    );
  }

  static GroupMember fromEntity(GroupMemberEntity entity) {
    return GroupMember(
      id: entity.id,
      name: entity.name,
      title: entity.title,
      photoUrl: entity.photoUrl,
      joinedOn: entity.joinedOn,
    );
  }

  GroupMemberEntity toEntity() {
    return GroupMemberEntity(
      id: id,
      name: name,
      title: title,
      photoUrl: photoUrl,
      joinedOn: joinedOn,
    );
  }
}
