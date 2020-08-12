import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  final Function onTap;

  const NextButton({
    Key key,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonTextStyle = Theme.of(context).textTheme.button;

    return SizedBox(
      width: 80,
      child: FlatButton(
        color: Palette.primaryColor,
        disabledColor: Palette.disabledButtonPrimaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Text('Next',
            style: buttonTextStyle.apply(
              fontWeightDelta: 1,
              color: Palette.whiteColor,
            )),
        onPressed: onTap,
      ),
    );
  }
}
