import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:flutter/material.dart';

class CommentButton extends StatelessWidget {
  final Post post;

  const CommentButton({
    Key key,
    @required this.style,
    @required this.post,
    @required Color sideTextColor,
  })  : _sideTextColor = sideTextColor,
        super(key: key);

  final TextStyle style;
  final Color _sideTextColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: kButtonTextSpacing),
            child: Icon(
              Icons.mode_comment,
              size: style.fontSize,
              color: _sideTextColor,
            ),
          ),
          Text(
            post.commentCount.toString(),
            style: style.apply(color: _sideTextColor, fontWeightDelta: 1),
          ),
        ],
      ),
    );
  }
}
