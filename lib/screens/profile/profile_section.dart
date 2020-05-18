import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class ProfileSection extends StatelessWidget {
  final Widget child;

  ProfileSection({this.child}) : assert(child != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: SizeConfig.instance.safeBlockVertical * 3),
      child: child,
    );
  }
}
