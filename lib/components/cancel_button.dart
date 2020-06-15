import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/material.dart';

class CancelButton extends StatelessWidget {
  final String text;
  final Function(BuildContext) onTap;

  CancelButton({@required this.onTap, this.text = 'Cancel'});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap(context);
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.button.apply(
                color: Palette.textColor,
              ),
        ),
      ),
    );
  }
}
