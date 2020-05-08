import 'package:canteen_frontend/models/comment/comment.dart';
import 'package:canteen_frontend/screens/posts/post_container.dart';
import 'package:canteen_frontend/screens/posts/post_name_template.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class CommentContainer extends StatelessWidget {
  final DetailedComment comment;
  final Color _sideTextColor = Colors.grey[500];

  CommentContainer({@required this.comment});

  @override
  Widget build(BuildContext context) {
    return PostContainer(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                bottom: SizeConfig.instance.blockSizeVertical * 2),
            child: PostNameTemplate(
              name: comment.user.displayName,
              photoUrl: comment.user.photoUrl,
              time: comment.createdOn,
              color: _sideTextColor,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              comment.message,
            ),
          ),
        ],
      ),
    );
  }
}
