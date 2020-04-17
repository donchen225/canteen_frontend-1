import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/utils/date_utils.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VideoChatDetailScreen extends StatefulWidget {
  final User user;

  VideoChatDetailScreen({@required this.user}) : assert(user != null);

  _VideoChatDetailScreenState createState() => _VideoChatDetailScreenState();
}

class _VideoChatDetailScreenState extends State<VideoChatDetailScreen> {
  String videoChatUrl;

  final double _kPickerSheetHeight = 216.0;
  final double _kPickerItemHeight = 32.0;

  DateTime dateTime = roundUpHour(DateTime.now(), Duration(hours: 1));

  Widget _buildMenu(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.inactiveGray,
        border: const Border(
          top: BorderSide(color: Color(0xFFBCBBC1), width: 0.0),
          bottom: BorderSide(color: Color(0xFFBCBBC1), width: 0.0),
        ),
      ),
      height: 44.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SafeArea(
          top: false,
          bottom: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: children,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: _kPickerSheetHeight,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }

  Widget _buildDateAndTimePicker(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            showCupertinoModalPopup<void>(
              context: context,
              builder: (BuildContext context) {
                return _buildBottomPicker(
                  CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.dateAndTime,
                    initialDateTime: dateTime,
                    minuteInterval: 15,
                    onDateTimeChanged: (DateTime newDateTime) {
                      if (mounted) {
                        setState(() => dateTime = newDateTime);
                      }
                    },
                  ),
                );
              },
            );
          },
          child: _buildMenu(
            <Widget>[
              Text(
                DateFormat.yMMMd().add_jm().format(dateTime),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProposedTimeRow(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
              top: SizeConfig.instance.safeBlockVertical * 3,
              bottom: SizeConfig.instance.safeBlockVertical * 3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Your proposed times'),
              _buildDateAndTimePicker(context),
              _buildDateAndTimePicker(context),
              _buildDateAndTimePicker(context),
              RaisedButton(
                child: Text('Submit'),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: SizeConfig.instance.safeBlockVertical * 3,
              bottom: SizeConfig.instance.safeBlockVertical * 3),
          child: Column(
            children: <Widget>[
              Text("${widget.user.displayName}'s proposed times"),
              _buildDateAndTimePicker(context),
              _buildDateAndTimePicker(context),
              _buildDateAndTimePicker(context),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: SizeConfig.instance.safeBlockVertical * 3,
              bottom: SizeConfig.instance.safeBlockVertical * 3),
          child: Column(
            children: <Widget>[
              Text('Video Chat Details'),
              RaisedButton(
                onPressed: () {
                  setState(() {
                    videoChatUrl = 'VIDEO CHAT URL';
                  });
                },
                child: Text('Get Video Chat'),
              ),
              Visibility(
                visible: videoChatUrl != null,
                child: Text(videoChatUrl ?? ''),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
