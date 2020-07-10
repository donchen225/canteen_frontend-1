import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class SmallButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  const SmallButton({
    Key key,
    @required this.text,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Palette.primaryColor,
      child: Text(
        text,
        style: Theme.of(context).textTheme.button.apply(
              color: Palette.whiteColor,
              fontWeightDelta: 2,
            ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.instance.safeBlockHorizontal * 10,
      ),
      onPressed: onPressed,
    );
  }
}
