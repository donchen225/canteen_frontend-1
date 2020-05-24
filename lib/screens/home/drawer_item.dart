import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final double height;

  DrawerItem({this.leading, this.title, this.height = 60});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: leading,
              ),
            ),
            Expanded(
              flex: 6,
              child: title,
            ),
          ],
        ));
  }
}
