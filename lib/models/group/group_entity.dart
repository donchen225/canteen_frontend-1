import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class GroupEntity extends Equatable {
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

  const GroupEntity(
      {@required this.id,
      @required this.name,
      @required this.description,
      @required this.photoUrl,
      @required this.tags,
      @required this.type,
      @required this.posts,
      @required this.members,
      @required this.lastUpdated,
      @required this.createdOn});

  Map<String, Object> toJson() {
    return {
      'id': id,
      'name': name,
      'photo_url': photoUrl,
      'description': description,
      'tags': tags,
      'type': type,
      'posts': posts,
      'members': members,
      'last_updated': lastUpdated,
      'created_on': createdOn,
    };
  }

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
    return 'GroupEntity { id: $id, name: $name, photoUrl: $photoUrl, description: $description, tags: $tags, type: $type, posts: $posts, members: $members, createdOn: $createdOn, lastUpdated $lastUpdated }';
  }

  static GroupEntity fromJson(Map<String, Object> json) {
    return GroupEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      photoUrl: json['photo_url'] as String,
      description: json['description'] as String,
      tags: json['tags'] as List<String>,
      type: json['type'] as String,
      posts: json['comment_count'] as int,
      members: json['like_count'] as int,
      createdOn: DateTime.parse(json['created_on']),
      lastUpdated: DateTime.parse(json['last_updated']),
    );
  }

  static GroupEntity fromSnapshot(DocumentSnapshot snapshot) {
    return GroupEntity(
      id: snapshot.documentID,
      name: snapshot.data['name'],
      photoUrl: snapshot.data['photo_url'],
      description: snapshot.data['description'],
      tags: snapshot.data['tags']?.map<String>((x) => x as String)?.toList() ??
          [],
      type: snapshot.data['type'],
      posts: snapshot.data['posts'],
      members: snapshot.data['members'],
      createdOn: snapshot.data["created_on"].toDate(),
      lastUpdated: snapshot.data['last_updated'].toDate(),
    );
  }

  Map<String, Object> toDocument() {
    return {
      'id': id,
      'name': name,
      'photo_url': photoUrl,
      'description': description,
      'tags': tags,
      'type': type,
      'comment_count': posts,
      'like_count': members,
      'created_on': createdOn,
      'last_updated': lastUpdated,
    };
  }
}
