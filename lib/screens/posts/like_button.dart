import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget {
  final DetailedPost post;
  final Color color;
  final Function onTap;

  const LikeButton({
    Key key,
    @required this.post,
    @required this.color,
    @required this.onTap,
  }) : super(key: key);

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool _tapped;
  int _likeCount;

  @override
  void initState() {
    super.initState();

    _tapped = widget.post.liked;
    _likeCount = widget.post.likeCount;
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle buttonTextStyle = Theme.of(context).textTheme.bodyText2;

    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap();
          setState(() {
            _tapped = !_tapped;

            _likeCount = _tapped ? _likeCount + 1 : _likeCount - 1;
          });
        }
      },
      child: Container(
          padding: EdgeInsets.only(
            left: SizeConfig.instance.blockSizeHorizontal * 3,
            right: SizeConfig.instance.blockSizeHorizontal * 3,
          ),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: kButtonTextSpacing),
                child: Container(
                  child: Image.asset(
                    'assets/up-arrow.png',
                    color: _tapped ? Palette.primaryColor : widget.color,
                    height: buttonTextStyle.fontSize,
                    width: buttonTextStyle.fontSize,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                _likeCount.toString(),
                style: buttonTextStyle.apply(
                    color: _tapped ? Palette.primaryColor : widget.color,
                    fontWeightDelta: 1),
              ),
            ],
          )),
    );
  }
}
