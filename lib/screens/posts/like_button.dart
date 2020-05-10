import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  const LikeButton({
    Key key,
    @required this.post,
    @required Color sideTextColor,
    @required this.style,
  })  : _sideTextColor = sideTextColor,
        super(key: key);

  final DetailedPost post;
  final Color _sideTextColor;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
          left: SizeConfig.instance.blockSizeHorizontal * 3,
          right: SizeConfig.instance.blockSizeHorizontal * 3,
        ),
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  right: SizeConfig.instance.blockSizeHorizontal * 2),
              child: Container(
                child: Image.asset(
                  'assets/up-arrow.png',
                  color: post.liked ? Colors.blue : _sideTextColor,
                  height: style.fontSize * 1.2,
                  width: style.fontSize * 1.2,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              post.likeCount.toString(),
              style: style.apply(
                  color: post.liked ? Colors.blue : _sideTextColor,
                  fontWeightDelta: 1),
            ),
          ],
        ));
  }
}
