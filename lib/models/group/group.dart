import 'package:canteen_frontend/models/group/group_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Group extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<String> tags;
  final int posts;
  final int members;
  final DateTime lastUpdated;
  final DateTime createdOn;

  const Group(
      {@required this.id,
      @required this.name,
      @required this.description,
      @required this.tags,
      @required this.posts,
      @required this.members,
      @required this.lastUpdated,
      @required this.createdOn});

  Map<String, Object> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'tags': tags,
      'posts': posts,
      'members': members,
      'last_updated': lastUpdated,
      'created_on': createdOn,
    };
  }

  @override
  List<Object> get props =>
      [id, name, description, tags, posts, members, lastUpdated, createdOn];

  @override
  String toString() {
    return 'Group { id: $id, name: $name, description: $description, tags: $tags, posts: $posts, members: $members, createdOn: $createdOn, lastUpdated $lastUpdated }';
  }

  static Group fromEntity(GroupEntity entity) {
    return Group(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      tags: entity.tags,
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
      description: description,
      tags: tags,
      posts: posts,
      members: members,
      lastUpdated: lastUpdated,
      createdOn: createdOn,
    );
  }
}
