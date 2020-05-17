import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class GroupListItem extends StatelessWidget {
  final Widget child;

  GroupListItem({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        right:
            SizeConfig.instance.safeBlockHorizontal * kHorizontalPaddingBlocks,
        left:
            SizeConfig.instance.safeBlockHorizontal * kHorizontalPaddingBlocks,
        bottom: SizeConfig.instance.safeBlockVertical * 2,
        top: SizeConfig.instance.safeBlockVertical * 2,
      ),
      decoration: BoxDecoration(
        color: Palette.containerColor,
      ),
      alignment: Alignment.centerLeft,
      child: child ?? Container(),
    );
  }
}
