import 'package:canteen_frontend/shared_blocs/authentication/bloc.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LikeButton extends StatelessWidget {
  final bool liked;
  final int likeCount;
  final Color color;
  final Function onTap;

  const LikeButton({
    Key key,
    @required this.liked,
    @required this.likeCount,
    @required this.color,
    @required this.onTap,
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
                    color: liked ? Palette.primaryColor : color,
                    height: buttonTextStyle.fontSize,
                    width: buttonTextStyle.fontSize,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                likeCount.toString(),
                style: buttonTextStyle.apply(
                    color: liked ? Palette.primaryColor : color,
                    fontWeightDelta: 1),
              ),
            ],
          )),
    );
  }
}
