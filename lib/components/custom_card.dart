import 'package:canteen_frontend/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Function onTap;
  final double height;
  final double width;
  final Widget child;

  CustomCard({
    this.onTap,
    this.height = 400,
    this.width = 300,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(kCardCircularRadius),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: child ?? Container(),
      ),
    );
  }
}
