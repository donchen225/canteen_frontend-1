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

class PostsInspectGroup extends PostScreenEvent {
  final Map<String, dynamic> group;

  const PostsInspectGroup(this.group);

  @override
  List<Object> get props => [group];

  @override
  String toString() {
    return 'PostsInspectGroup { group: $group }';
  }
}

class DiscoverGroups extends PostScreenEvent {}

class PostsPreviousState extends PostScreenEvent {}
