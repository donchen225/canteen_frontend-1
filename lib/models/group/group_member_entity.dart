import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class GroupMemberEntity extends Equatable {
  final String id;
  final String name;
  final String title;
  final String photoUrl;
  final DateTime joinedOn;

  const GroupMemberEntity({
    @required this.id,
    @required this.name,
    @required this.title,
    @required this.photoUrl,
    @required this.joinedOn,
  });

  Map<String, Object> toJson() {
    return {
      'id': id,
      'display_name': name,
      'title': title,
      'photo_url': photoUrl,
      'joined_on': joinedOn,
    };
  }

  @override
  List<Object> get props => [id, name, title, photoUrl, joinedOn];

  @override
  String toString() {
    return 'GroupMemberEntity { id: $id, name: $name, title: $title, photoUrl: $photoUrl, joinedOn: $joinedOn }';
  }

  static GroupMemberEntity fromJson(Map<String, Object> json) {
    return GroupMemberEntity(
      id: json['id'] as String,
      name: json['display_name'] as String,
      title: json['title'] as String,
      photoUrl: json['photo_url'] as String,
      joinedOn: DateTime.parse(json['joined_on']),
    );
  }

  static GroupMemberEntity fromSnapshot(DocumentSnapshot snapshot) {
    return GroupMemberEntity(
      id: snapshot.documentID,
      name: snapshot.data['display_name'],
      title: snapshot.data['title'],
      photoUrl: snapshot.data['photo_url'],
      joinedOn: snapshot.data["joined_on"]?.toDate(),
    );
  }

  Map<String, Object> toDocument() {
    return {
      'display_name': name,
      'title': title,
      'photo_url': photoUrl,
      'joinedOn': joinedOn,
    };
  }
}
