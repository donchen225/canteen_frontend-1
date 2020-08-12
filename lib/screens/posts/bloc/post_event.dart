import 'package:canteen_frontend/models/comment/comment.dart';
import 'package:canteen_frontend/models/like/like.dart';
import 'package:canteen_frontend/models/post/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:tuple/tuple.dart';
import 'package:meta/meta.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class LoadPosts extends PostEvent {
  final String groupId;

  const LoadPosts({this.groupId});

  @override
  String toString() => 'LoadPosts { groupId: $groupId }';
}

class AddPost extends PostEvent {
  final String groupId;
  final Post post;

  const AddPost({this.groupId, this.post});

  @override
  List<Object> get props => [post];

  @override
  String toString() => 'AddPost { post: $post }';
}

class AddLike extends PostEvent {
  final String groupId;
  final String postId;
  final Like like;

  const AddLike({this.groupId, this.postId, this.like});

  @override
  List<Object> get props => [groupId, postId, like];

  @override
  String toString() =>
      'AddLike { groupId: $groupId, postId: $postId, like: $like }';
}

class AddComment extends PostEvent {
  final String groupId;
  final String postId;
  final Comment comment;

  const AddComment(
      {@required this.groupId, @required this.postId, @required this.comment});

  @override
  List<Object> get props => [groupId, postId, comment];

  @override
  String toString() =>
      'AddComment { groupId: $groupId, postId: $postId comment: $comment }';
}

class DeleteLike extends PostEvent {
  final String groupId;
  final String postId;

  const DeleteLike({this.groupId, this.postId});

  @override
  List<Object> get props => [groupId, postId];

  @override
  String toString() => 'DeleteLike { groupId: $groupId, postId: $postId }';
}

class UpdatePost extends PostEvent {
  final Post post;

  const UpdatePost(this.post);

  @override
  List<Object> get props => [post];

  @override
  String toString() => 'UpdatePost { post: $post }';
}

class DeletePost extends PostEvent {
  final Post post;

  const DeletePost(this.post);

  @override
  List<Object> get props => [post];

  @override
  String toString() => 'DeletePost { post: $post }';
}

class PostsUpdated extends PostEvent {
  final String groupId;
  final Tuple2<List<Post>, DocumentSnapshot> updates;

  const PostsUpdated({this.groupId, this.updates});

  @override
  List<Object> get props => [groupId, updates];

  @override
  String toString() => 'PostsUpdated { groupId: $groupId, updates: $updates }';
}

class ClearPosts extends PostEvent {}
