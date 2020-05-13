import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback _onPressed;

  LoginButton({Key key, VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonStyle = Theme.of(context).textTheme.button.apply(
          color: Palette.buttonDarkTextColor,
        );

    return RaisedButton(
      color: Palette.orangeColor,
      disabledColor: Palette.orangeColor.withOpacity(kDisabledOpacity),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      onPressed: _onPressed,
      child: Text(
        'Log In',
        style: buttonStyle,
      ),
    );
  }
}
