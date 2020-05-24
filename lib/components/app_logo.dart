import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final Color color;

  AppLogo({this.size = 50, this.color = const Color(0xFFEE8442)});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            height: size,
            width: size,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              // border: Border.all(
              //   width: 3,
              //   color: Colors.grey[300],
              // ),
            ),
          ),
          Container(
            height: size * 0.65,
            width: size * 0.65,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            // constraints: BoxConstraints(maxHeight: 50, maxWidth: 50),
            child: Image.asset(
              'assets/loading-icon.png',
              color: Colors.white,
              // fit: BoxFit.fitHeight,
            ),
          ),
        ],
      ),
    );
  }
}
