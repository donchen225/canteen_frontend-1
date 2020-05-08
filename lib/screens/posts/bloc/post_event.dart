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
  const LoadPosts();

  @override
  String toString() => 'LoadPosts';
}

class AddPost extends PostEvent {
  final Post post;

  const AddPost(this.post);

  @override
  List<Object> get props => [post];

  @override
  String toString() => 'AddPost { post: $post }';
}

class AddLike extends PostEvent {
  final String postId;
  final Like like;

  const AddLike(this.postId, this.like);

  @override
  List<Object> get props => [postId, like];

  @override
  String toString() => 'AddLike { postId: $postId, like: $like }';
}

class DeleteLike extends PostEvent {
  final String postId;

  const DeleteLike(this.postId);

  @override
  List<Object> get props => [postId];

  @override
  String toString() => 'DeleteLike { postId: $postId }';
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
  final List<Tuple2<DocumentChangeType, Post>> updates;

  const PostsUpdated(this.updates);

  @override
  List<Object> get props => [updates];

  @override
  String toString() => 'PostsUpdated { updates: $updates }';
}

class ClearPosts extends PostEvent {}
