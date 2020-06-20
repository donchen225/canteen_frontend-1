import 'package:canteen_frontend/models/request/request.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConfirmRequestDialog extends StatefulWidget {
  final User user;
  final Request request;
  final Function onTap;

  ConfirmRequestDialog({this.user, this.request, this.onTap});

  @override
  _ConfirmRequestDialogState createState() => _ConfirmRequestDialogState();
}

class _ConfirmRequestDialogState extends State<ConfirmRequestDialog> {
  final DateFormat timeFormat = DateFormat.jm();
  bool _pressed = false;

  Widget _buildDescription(BuildContext context) {
    var description;

    switch (widget.request.type) {
      case "offer":
        description =
            " would like to take you up on your offer for \"${widget.request.skill}\".";
        break;
      case "request":
        description =
            " would like to fulfill your request for \"${widget.request.skill}\".";
        break;
      default:
        return Container();
    }

    final textStyle = Theme.of(context).textTheme.bodyText1;

    return RichText(
        textAlign: TextAlign.start,
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(style: textStyle, children: [
          TextSpan(
            text: '${widget.user.displayName}',
            style: textStyle.apply(
              fontWeightDelta: 2,
            ),
          ),
          TextSpan(text: description),
        ]));
  }

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
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'Request Details',
              style: Theme.of(context).textTheme.headline5.apply(
                    fontWeightDelta: 1,
                  ),
            ),
          ),
          _buildDescription(context),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              widget.request.skill,
              style: bodyTextStyle.apply(
                fontWeightDelta: 2,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              const Icon(IconData(0xf26e,
                  fontFamily: CupertinoIcons.iconFont,
                  fontPackage: CupertinoIcons.iconFontPackage)),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.instance.safeBlockHorizontal * 3,
                ),
                child: Text(
                  '${widget.request.duration.toString()} min',
                  style: bodyTextStyle,
                ),
              ),
            ],
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
                        DateFormat('yMMMMEEEEd').format(widget.request.time),
                        style: timeTextStyle,
                      ),
                      Text(
                        '${timeFormat.format(widget.request.time)} - ${timeFormat.format(widget.request.time.add(Duration(minutes: widget.request.duration)))} ${widget.request.time.timeZoneName}',
                        style: timeTextStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              const Icon(Icons.attach_money),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.instance.safeBlockHorizontal * 3,
                ),
                child: Text(
                  '${widget.request.price.toStringAsFixed(2)}',
                  style: bodyTextStyle,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              'Payment will be requested before the offer/request is completed. Payment will be sent after the offer/request is complete.',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .apply(color: Palette.textSecondaryBaseColor),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: RaisedButton(
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
            ),
          )
        ],
      ),
    );
  }
}
