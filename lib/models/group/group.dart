import 'package:canteen_frontend/models/group/group_entity.dart';
import 'package:canteen_frontend/models/group/group_member.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Group extends Equatable {
  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final List<String> tags;
  final String type;
  final int posts;
  final int members;
  final DateTime lastUpdated;
  final DateTime createdOn;

  const Group(
      {@required this.id,
      @required this.name,
      @required this.photoUrl,
      @required this.description,
      @required this.tags,
      @required this.type,
      @required this.posts,
      @required this.members,
      @required this.lastUpdated,
      @required this.createdOn});

  @override
  List<Object> get props => [
        id,
        name,
        photoUrl,
        description,
        tags,
        type,
        posts,
        members,
        lastUpdated,
        createdOn
      ];

  @override
  String toString() {
    return 'Group { id: $id, name: $name, photoUrl: $photoUrl, description: $description, tags: $tags, type: $type, posts: $posts, members: $members, createdOn: $createdOn, lastUpdated $lastUpdated }';
  }

  static Group fromEntity(GroupEntity entity) {
    return Group(
      id: entity.id,
      name: entity.name,
      photoUrl: entity.photoUrl,
      description: entity.description,
      tags: entity.tags,
      type: entity.type,
      posts: entity.posts,
      members: entity.members,
      createdOn: entity.createdOn,
      lastUpdated: entity.lastUpdated,
    );
  }

  GroupEntity toEntity() {
    return GroupEntity(
      id: id,
      name: name,
      photoUrl: photoUrl,
      description: description,
      tags: tags,
      type: type,
      posts: posts,
      members: members,
      lastUpdated: lastUpdated,
      createdOn: createdOn,
    );
  }
}

class DetailedGroup extends Group {
  final List<GroupMember> memberList;

  DetailedGroup(
      {@required id,
      @required name,
      @required description,
      @required photoUrl,
      @required tags,
      @required type,
      @required posts,
      @required members,
      @required lastUpdated,
      @required createdOn,
      @required this.memberList})
      : super(
            id: id,
            name: name,
            description: description,
            photoUrl: photoUrl,
            tags: tags,
            type: type,
            posts: posts,
            members: members,
            lastUpdated: lastUpdated,
            createdOn: createdOn);

  static DetailedGroup fromGroup(Group group, List<GroupMember> memberList) {
    return DetailedGroup(
        id: group.id,
        name: group.name,
        description: group.description,
        photoUrl: group.photoUrl,
        tags: group.tags,
        type: group.type,
        posts: group.posts,
        members: group.members,
        createdOn: group.createdOn,
        lastUpdated: group.lastUpdated,
        memberList: memberList);
  }
}
