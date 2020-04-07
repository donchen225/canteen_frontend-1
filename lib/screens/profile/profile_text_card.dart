import 'package:flutter/material.dart';

class ProfileTextCard extends StatelessWidget {
  final Widget child;
  final double height;

  ProfileTextCard({this.child, this.height = 100});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey[200]),
        borderRadius: BorderRadius.circular(6),
      ),
      margin: EdgeInsets.all(0),
      elevation: 0.3,
      color: Colors.white,
      child: Container(
        height: height,
        padding: EdgeInsets.all(15),
        child: child ?? Container(),
      ),
    );
  }
}
