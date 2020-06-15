import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final bool enabled;
  final Function(BuildContext) onTap;

  ActionButton({@required this.onTap, this.enabled = true, this.text = 'Post'});

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
          left: 15,
          right: 15,
        ),
        decoration: BoxDecoration(
            color: enabled
                ? Palette.primaryColor
                : Palette.primaryColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20)),
        child: Text(
          text,
          style: Theme.of(context).textTheme.button.apply(
                color: Colors.white,
                fontWeightDelta: 1,
              ),
        ),
      ),
    );
  }
}
