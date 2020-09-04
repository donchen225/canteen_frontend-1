import 'package:canteen_frontend/shared_blocs/authentication/bloc.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LikeButton extends StatelessWidget {
  final bool liked;
  final int likeCount;
  final Color color;
  final Function onTap;
  final double size;

  const LikeButton({
    Key key,
    @required this.liked,
    @required this.likeCount,
    @required this.color,
    @required this.onTap,
    this.size = 26,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle buttonTextStyle = Theme.of(context).textTheme.bodyText2;

    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          final authenticated = BlocProvider.of<AuthenticationBloc>(context)
              .state is Authenticated;

          if (authenticated) {
            onTap();
          }
        }
      },
      child: Container(
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
                    right: size > 26
                        ? kButtonTextSpacing * 1.5
                        : kButtonTextSpacing),
                alignment: Alignment.center,
                child: FaIcon(
                  liked ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
                  color: liked ? Palette.primaryColor : color,
                  size: size * 0.65,
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  likeCount.toString(),
                  style: buttonTextStyle.apply(
                      color: liked ? Palette.primaryColor : color,
                      fontSizeFactor: size > 26 ? 1.1 : 0.92,
                      fontWeightDelta: 1),
                ),
              ),
            ],
          )),
    );
  }
}
