import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConfirmRequestDialog extends StatefulWidget {
  final String skill;
  final DateTime time;
  final Function onTap;

  ConfirmRequestDialog({this.skill, this.time, this.onTap});

  @override
  _ConfirmRequestDialogState createState() => _ConfirmRequestDialogState();
}

class _ConfirmRequestDialogState extends State<ConfirmRequestDialog> {
  final DateFormat timeFormat = DateFormat.jm();
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final bodyTextStyle = Theme.of(context).textTheme.bodyText1;
    final buttonTextStyle = Theme.of(context).textTheme.button;
    final timeTextStyle = bodyTextStyle.apply(color: Colors.green);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            child: Text(
              'Request Details',
              style: Theme.of(context).textTheme.headline5.apply(
                    fontWeightDelta: 1,
                  ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Text(widget.skill),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              children: <Widget>[
                const Icon(IconData(0xf2d1,
                    fontFamily: CupertinoIcons.iconFont,
                    fontPackage: CupertinoIcons.iconFontPackage)),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.instance.safeBlockHorizontal * 3,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        DateFormat('yMMMMEEEEd').format(widget.time),
                        style: timeTextStyle,
                      ),
                      Text(
                        '${timeFormat.format(widget.time)} - ${timeFormat.format(widget.time)} ${widget.time.timeZoneName}',
                        style: timeTextStyle,
                      ),
                    ],
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
