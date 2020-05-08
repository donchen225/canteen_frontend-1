import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class PostContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  PostContainer({@required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          EdgeInsets.only(
            left: SizeConfig.instance.blockSizeHorizontal * 4,
            right: SizeConfig.instance.blockSizeHorizontal * 4,
            top: SizeConfig.instance.blockSizeHorizontal * 6,
            bottom: SizeConfig.instance.blockSizeHorizontal * 6,
          ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.grey[200]),
          top: BorderSide(width: 1, color: Colors.grey[200]),
        ),
      ),
      child: child,
    );
  }
}
