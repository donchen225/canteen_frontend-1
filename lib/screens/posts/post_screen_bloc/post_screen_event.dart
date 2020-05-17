import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:equatable/equatable.dart';

abstract class PostScreenEvent extends Equatable {
  const PostScreenEvent();

  @override
  List<Object> get props => [];
}

class PostsHome extends PostScreenEvent {}

class PostsInspectPost extends PostScreenEvent {
  final Post post;

  const PostsInspectPost(this.post);

  @override
  List<Object> get props => [post];

  @override
  String toString() {
    return 'PostsInspectPost { post: $post }';
  }
}

class PostsInspectUser extends PostScreenEvent {
  final User user;

  const PostsInspectUser(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() {
    return 'PostsInspectUser { user: ${user.id}, ${user.displayName} }';
  }
}

class PostsPreviousState extends PostScreenEvent {}
