import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddIcon extends StatelessWidget {
  final double size;
  final Function onTap;

  AddIcon(this.size, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        height: size / 4,
        width: size / 4,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Container(
          height: (size / 4) - 4,
          width: (size / 4) - 4,
          decoration: BoxDecoration(
            color: Palette.primaryColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: size / 6,
          ),
        ),
      ),
    );
  }
}
