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
          border: Border.all(
            width: 2,
            color: Colors.white,
          ),
          color: Colors.blue[500],
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(
          CupertinoIcons.add,
          color: Colors.white,
          size: size / 5,
        ),
      ),
    );
  }
}
