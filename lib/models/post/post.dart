import 'package:canteen_frontend/models/post/post_entity.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Post extends Equatable {
  final String id;
  final String from;
  final String message;
  final List<String> tags;
  final int commentCount;
  final int likeCount;
  final DateTime lastUpdated;
  final DateTime createdOn;

  const Post(
      {this.id,
      @required this.from,
      this.message,
      this.tags,
      this.commentCount = 0,
      this.likeCount = 0,
      @required this.lastUpdated,
      @required this.createdOn});

  @override
  List<Object> get props => [
        id,
        from,
        message,
        tags,
        commentCount,
        likeCount,
        lastUpdated,
        createdOn,
      ];

  @override
  String toString() {
    return 'Post { id: $id, from: $from, message: $message, tags: $tags, commentCount: $commentCount, likeCount: $likeCount, createdOn: $createdOn, lastUpdated $lastUpdated }';
  }

  static Post fromEntity(PostEntity entity) {
    return Post(
      id: entity.id,
      from: entity.from,
      message: entity.message,
      tags: entity.tags,
      commentCount: entity.commentCount,
      likeCount: entity.likeCount,
      createdOn: entity.createdOn,
      lastUpdated: entity.lastUpdated,
    );
  }

  PostEntity toEntity() {
    return PostEntity(
      id: id,
      from: from,
      message: message,
      tags: tags,
      commentCount: commentCount,
      likeCount: likeCount,
      lastUpdated: lastUpdated,
      createdOn: createdOn,
    );
  }

  Post incrementLikeCount() {
    return Post(
      id: id,
      from: from,
      message: message,
      tags: tags,
      commentCount: commentCount,
      likeCount: likeCount + 1,
      createdOn: createdOn,
      lastUpdated: lastUpdated,
    );
  }

  Post decrementLikeCount() {
    return Post(
      id: id,
      from: from,
      message: message,
      tags: tags,
      commentCount: commentCount,
      likeCount: likeCount - 1,
      createdOn: createdOn,
      lastUpdated: lastUpdated,
    );
  }
}

class DetailedPost extends Post {
  final User user;
  final bool liked;

  DetailedPost({
    @required id,
    @required from,
    @required message,
    @required tags,
    @required commentCount,
    @required likeCount,
    @required createdOn,
    @required lastUpdated,
    @required this.user,
    @required this.liked,
  }) : super(
            id: id,
            from: from,
            message: message,
            tags: tags,
            commentCount: commentCount,
            likeCount: likeCount,
            lastUpdated: lastUpdated,
            createdOn: createdOn);

  @override
  List<Object> get props => [
        id,
        from,
        message,
        tags,
        commentCount,
        likeCount,
        lastUpdated,
        createdOn,
        user,
        liked,
      ];

  static DetailedPost fromPost(
    Post post,
    User user,
    bool liked,
  ) {
    return DetailedPost(
      id: post.id,
      from: post.from,
      message: post.message,
      tags: post.tags,
      commentCount: post.commentCount,
      likeCount: post.likeCount,
      createdOn: post.createdOn,
      lastUpdated: post.lastUpdated,
      user: user,
      liked: liked,
    );
  }

  DetailedPost incrementLikeCount() {
    return DetailedPost(
      id: id,
      from: from,
      message: message,
      tags: tags,
      commentCount: commentCount,
      likeCount: likeCount + 1,
      createdOn: createdOn,
      lastUpdated: lastUpdated,
      user: user,
      liked: true,
    );
  }

  DetailedPost decrementLikeCount() {
    return DetailedPost(
      id: id,
      from: from,
      message: message,
      tags: tags,
      commentCount: commentCount,
      likeCount: likeCount - 1,
      createdOn: createdOn,
      lastUpdated: lastUpdated,
      user: user,
      liked: false,
    );
  }

  DetailedPost copy() {
    return DetailedPost(
      id: id,
      from: from,
      message: message,
      tags: tags,
      commentCount: commentCount,
      likeCount: likeCount,
      createdOn: createdOn,
      lastUpdated: lastUpdated,
      user: user,
      liked: liked,
    );
  }
}
