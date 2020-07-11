import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/size_config.dart';
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
      color: Colors.white,
      alignment: Alignment.center,
      padding: EdgeInsets.only(
        top: SizeConfig.instance.safeBlockVertical * 0.5,
        bottom: SizeConfig.instance.safeBlockVertical * 0.5,
      ),
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
