import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class CommentButton extends StatelessWidget {
  const CommentButton({
    Key key,
    @required this.style,
    @required Color sideTextColor,
  })  : _sideTextColor = sideTextColor,
        super(key: key);

  final TextStyle style;
  final Color _sideTextColor;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyText1;

    return Container(
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                right: SizeConfig.instance.blockSizeHorizontal * 2),
            child: Icon(
              Icons.mode_comment,
              size: style.fontSize * 1.4,
              color: _sideTextColor,
            ),
          ),
          Text(
            'Comment',
            style: style.apply(color: _sideTextColor, fontWeightDelta: 1),
          ),
        ],
      ),
    );
  }
}
