import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class ProfileTextCard extends StatelessWidget {
  final Widget child;
  final double height;
  final Color color;

  ProfileTextCard({this.child, this.height, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          width: 0.5,
          color: Palette.borderSeparatorColor,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.all(SizeConfig.instance.safeBlockHorizontal * 4),
      child: child ?? Container(),
    );
  }
}
