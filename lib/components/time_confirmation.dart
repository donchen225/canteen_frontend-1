import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeConfirmation extends StatefulWidget {
  final DateTime time;
  final int duration;
  final Function onMessageUpdated;

  TimeConfirmation({
    @required this.time,
    @required this.duration,
    this.onMessageUpdated,
  })  : assert(time != null),
        assert(duration != null);

  @override
  _TimeConfirmationState createState() => _TimeConfirmationState();
}

class _TimeConfirmationState extends State<TimeConfirmation> {
  final DateFormat timeFormat = DateFormat.jm();
  TextEditingController _messageController;

  @override
  void initState() {
    super.initState();

    _messageController = TextEditingController();

    if (widget.onMessageUpdated != null) {
      _messageController.addListener(() {
        widget.onMessageUpdated(_messageController.text);
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bodyTextStyle =
        Theme.of(context).textTheme.bodyText2.apply(fontWeightDelta: 1);
    final timeTextStyle = bodyTextStyle.apply(color: Colors.green);

    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 24),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                      child: Text('Request Details',
                          style: Theme.of(context).textTheme.headline6)),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.instance.safeBlockVertical * 2,
                        ),
                        child: Row(
                          children: <Widget>[
                            const Icon(IconData(0xf26e,
                                fontFamily: CupertinoIcons.iconFont,
                                fontPackage: CupertinoIcons.iconFontPackage)),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    SizeConfig.instance.safeBlockHorizontal * 3,
                              ),
                              child: Text(
                                '${widget.duration.toString()} min',
                                style: bodyTextStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          const Icon(IconData(0xf2d1,
                              fontFamily: CupertinoIcons.iconFont,
                              fontPackage: CupertinoIcons.iconFontPackage)),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  SizeConfig.instance.safeBlockHorizontal * 3,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  DateFormat('yMMMMEEEEd').format(widget.time),
                                  style: timeTextStyle,
                                ),
                                Text(
                                  '${timeFormat.format(widget.time)} - ${timeFormat.format(widget.time.add(Duration(minutes: widget.duration)))} ${widget.time.timeZoneName}',
                                  style: timeTextStyle,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.instance.safeBlockVertical * 3,
                  ),
                  child: TextField(
                    controller: _messageController,
                    textCapitalization: TextCapitalization.sentences,
                    autofocus: false,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey[500], width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey[500], width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey[500], width: 1.0),
                      ),
                      hintText: 'Add a message',
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
