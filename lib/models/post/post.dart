import 'package:canteen_frontend/models/post/post_entity.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Post extends Equatable {
  final String id;
  final String from;
  final String title;
  final String message;
  final List<String> tags;
  final DateTime lastUpdated;
  final DateTime createdOn;

  const Post(
      {this.id,
      @required this.from,
      @required this.title,
      this.message,
      this.tags,
      @required this.lastUpdated,
      @required this.createdOn});

  @override
  List<Object> get props => [
        id,
        from,
        title,
        message,
        tags,
        lastUpdated,
        createdOn,
      ];

  @override
  String toString() {
    return 'MatchEntity { id: $id, from: $from, title: $title, message: $message, tags: $tags, createdOn: $createdOn, lastUpdated $lastUpdated }';
  }

  static Post fromEntity(PostEntity entity) {
    return Post(
      id: entity.id,
      from: entity.from,
      title: entity.title,
      message: entity.message,
      tags: entity.tags,
      createdOn: entity.createdOn,
      lastUpdated: entity.lastUpdated,
    );
  }

  PostEntity toEntity() {
    return PostEntity(
      id: id,
      from: from,
      title: title,
      message: message,
      tags: tags,
      lastUpdated: lastUpdated,
      createdOn: createdOn,
    );
  }
}

class DetailedPost extends Post {
  final User user;

  DetailedPost({
    @required id,
    @required from,
    @required title,
    @required message,
    @required tags,
    @required createdOn,
    @required lastUpdated,
    @required this.user,
  }) : super(
            id: id,
            from: from,
            title: title,
            message: message,
            tags: tags,
            lastUpdated: lastUpdated,
            createdOn: createdOn);

  static DetailedPost fromPost(
    Post post,
    User user,
  ) {
    return DetailedPost(
      id: post.id,
      from: post.from,
      title: post.title,
      message: post.message,
      tags: post.tags,
      createdOn: post.createdOn,
      lastUpdated: post.lastUpdated,
      user: user,
    );
  }
}
