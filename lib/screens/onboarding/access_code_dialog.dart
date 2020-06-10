import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/material.dart';

class AccessCodeDialog extends StatefulWidget {
  @override
  _AccessCodeDialogState createState() => _AccessCodeDialogState();
}

class _AccessCodeDialogState extends State<AccessCodeDialog> {
  TextEditingController _controller;
  bool _error = false;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
    _controller.addListener(_resetError);
  }

  void _resetError() {
    setState(() {
      _error = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bodyTextStyle = Theme.of(context).textTheme.bodyText1;
    final buttonTextStyle = Theme.of(context).textTheme.button;

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            child: Text(
              'Enter access code',
              style: Theme.of(context).textTheme.bodyText1.apply(
                    fontWeightDelta: 2,
                  ),
            ),
          ),
          Container(
            height: 70,
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  cursorColor: Palette.primaryColor,
                  style: bodyTextStyle.apply(
                    color: Palette.textColor,
                  ),
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                Visibility(
                  visible: _error,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 3),
                    child: Text('Invalid access code',
                        style:
                            bodyTextStyle.apply(color: Palette.textErrorColor)),
                  ),
                ),
              ],
            ),
          ),
          RaisedButton(
            elevation: 0,
            focusElevation: 0,
            disabledElevation: 0,
            highlightElevation: 0,
            hoverElevation: 0,
            color: Colors.transparent,
            focusColor: Palette.primaryColor.withOpacity(0.4),
            highlightColor: Palette.primaryColor.withOpacity(0.4),
            hoverColor: Palette.primaryColor.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: Palette.primaryColor,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            onPressed: () {
              setState(() {
                _error = true;
              });
            },
            child: Text(
              'Join',
              style: buttonTextStyle.apply(
                fontWeightDelta: 1,
                color: Palette.primaryColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
