import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class PostButton extends StatelessWidget {
  final String text;
  final bool enabled;
  final Function(BuildContext) onTap;

  PostButton(
      {@required this.onTap, @required this.enabled, this.text = 'POST'});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap(context);
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          top: SizeConfig.instance.blockSizeVertical * 2,
          bottom: SizeConfig.instance.blockSizeVertical * 2,
          left: SizeConfig.instance.blockSizeHorizontal * 3,
          right: SizeConfig.instance.blockSizeHorizontal * 3,
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.button.apply(
                color: enabled
                    ? Palette.orangeColor
                    : Palette.orangeColor.withOpacity(0.4),
                fontWeightDelta: 1,
              ),
        ),
      ),
    );
  }
}
