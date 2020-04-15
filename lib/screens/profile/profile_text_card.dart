import 'package:flutter/material.dart';

class ProfileTextCard extends StatelessWidget {
  final Widget child;
  final double height;
  final Color color;

  ProfileTextCard({this.child, this.height = 100, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey[200]),
        borderRadius: BorderRadius.circular(6),
      ),
      margin: EdgeInsets.all(0),
      elevation: 0.3,
      color: color,
      child: Container(
        height: height,
        padding: EdgeInsets.all(10),
        child: child ?? Container(),
      ),
    );
  }
}
