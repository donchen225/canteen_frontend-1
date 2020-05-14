import 'package:canteen_frontend/utils/constants.dart';
import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final double height;
  final Color color;
  final Color textColor;
  final String text;
  final VoidCallback onPressed;

  MainButton(
      {Key key,
      this.height = 50,
      this.color = const Color(0xFFEE8442),
      this.textColor = const Color(0xFFFFFFFF),
      this.text = '',
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonStyle = Theme.of(context).textTheme.button;

    return Container(
      height: height,
      child: RaisedButton(
        elevation: 0,
        highlightElevation: 0,
        color: color,
        disabledColor: color.withOpacity(kDisabledOpacity),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: buttonStyle.apply(
            color: textColor,
            fontWeightDelta: 1,
            fontSizeFactor:
                height / kButtonHeightToFontRatio / buttonStyle.fontSize,
          ),
        ),
      ),
    );
  }
}
