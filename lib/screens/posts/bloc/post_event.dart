import 'package:canteen_frontend/models/post/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:tuple/tuple.dart';

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
