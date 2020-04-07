import 'package:flutter/material.dart';

class ProfileTextCard extends StatelessWidget {
  final Widget child;

  ProfileTextCard({this.child});

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
        height: 100,
        padding: EdgeInsets.all(15),
        child: child ?? Container(),
      ),
    );
  }
}
