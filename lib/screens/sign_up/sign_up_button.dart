import 'package:flutter/material.dart';

class SignUpButton extends StatelessWidget {
  final VoidCallback _onPressed;

  SignUpButton({Key key, VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.blue, // TODO: extract to style
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      onPressed: _onPressed,
      child: Text('Sign Up'),
    );
  }
}
