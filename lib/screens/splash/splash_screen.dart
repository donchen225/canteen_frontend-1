import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      color: Colors.white,
      child: Container(
        height: 140,
        width: 140,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/loading-icon.png'),
          ),
        ),
      ),
    );
  }
}
