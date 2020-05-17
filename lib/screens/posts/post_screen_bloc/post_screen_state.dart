import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:equatable/equatable.dart';

class PostScreenState extends Equatable {
  const PostScreenState();

  @override
  List<Object> get props => [];
}

class PostScreenHome extends PostScreenState {
  final List<Post> posts;
  final User user;

  const PostScreenHome({this.posts, this.user})
      : assert(posts != null),
        assert(user != null);

  @override
  List<Object> get props => [posts, user];

  @override
  String toString() => 'PostScreenHome';
}

class PostScreenLoading extends PostScreenState {}

class PostScreenShowProfile extends PostScreenState {
  final User user;

  const PostScreenShowProfile(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'PostScreenShowProfile';
}

class PostScreenShowPost extends PostScreenState {
  final Post post;
  final User user;

  const PostScreenShowPost({this.post, this.user});

  @override
  List<Object> get props => [post, user];

  @override
  String toString() => 'PostScreenShowPost';
}
