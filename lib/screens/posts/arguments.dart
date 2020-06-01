import 'package:canteen_frontend/models/post/post.dart';

class SinglePostArguments {
  final Post post;
  final String groupId;

  SinglePostArguments({this.post, this.groupId})
      : assert(post != null),
        assert(groupId != null);
}
