import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/material.dart';

class ConfirmRequestDialog extends StatefulWidget {
  final String skill;
  final Function onTap;

  ConfirmRequestDialog({this.skill, this.onTap});

  @override
  _ConfirmRequestDialogState createState() => _ConfirmRequestDialogState();
}

class _ConfirmRequestDialogState extends State<ConfirmRequestDialog> {
  bool _pressed = false;

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
              'Confirm Request',
              style: Theme.of(context).textTheme.bodyText1.apply(
                    fontWeightDelta: 2,
                  ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Text(widget.skill),
          ),
          RaisedButton(
            elevation: 0,
            focusElevation: 0,
            disabledElevation: 0,
            highlightElevation: 0,
            hoverElevation: 0,
            color: Palette.primaryColor,
            focusColor: Palette.primaryColor.withOpacity(0.4),
            highlightColor: Palette.primaryColor.withOpacity(0.4),
            hoverColor: Palette.primaryColor.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onPressed: () {
              if (widget.onTap != null) {
                widget.onTap();
              }
              Navigator.maybePop(context, true);
            },
            child: Text(
              'Confirm',
              style: buttonTextStyle.apply(
                fontWeightDelta: 1,
                color: Palette.whiteColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
