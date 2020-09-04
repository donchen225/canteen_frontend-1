import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CommentButton extends StatelessWidget {
  final Post post;
  final double size;

  const CommentButton({
    Key key,
    @required this.style,
    @required this.post,
    @required Color sideTextColor,
    this.size = 26,
  })  : _sideTextColor = sideTextColor,
        super(key: key);

  final TextStyle style;
  final Color _sideTextColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      color: Colors.transparent,
      padding: EdgeInsets.only(
        left: SizeConfig.instance.blockSizeHorizontal * 3,
        right: SizeConfig.instance.blockSizeHorizontal * 3,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                right:
                    size > 26 ? kButtonTextSpacing * 1.5 : kButtonTextSpacing),
            alignment: Alignment.center,
            child: FaIcon(
              FontAwesomeIcons.comment,
              size: size * 0.65,
              color: _sideTextColor,
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              post.commentCount.toString(),
              style: style.apply(
                color: _sideTextColor,
                fontSizeFactor: size > 26 ? 1.1 : 0.92,
                fontWeightDelta: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
