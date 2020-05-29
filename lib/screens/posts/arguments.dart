import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/models/user/user.dart';

class UserPostArguments {
  final User user;

  UserPostArguments({this.user});
}

class SinglePostArguments {
  final Post post;

  SinglePostArguments({this.post}) : assert(post != null);
}
