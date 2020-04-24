import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/video_chat_details/video_chat_time_picker.dart';
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

  DateTime initialDateTime = roundUpHour(DateTime.now(), Duration(hours: 1));
  DateTime proposedDate1;
  DateTime proposedDate2;
  DateTime proposedDate3;

  @override
  void initState() {
    super.initState();

    print(initialDateTime);
    proposedDate1 = initialDateTime;
    proposedDate2 = initialDateTime;
    proposedDate3 = initialDateTime;
  }

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

  Widget _buildDateAndTimePicker(BuildContext context, DateTime date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            showCupertinoModalPopup<void>(
              context: context,
              builder: (BuildContext context) {
                return VideoChatTimePicker(
                  initialTime: initialDateTime,
                  onChanged: (dateTime) {
                    setState(() {
                      date = dateTime;
                      print(proposedDate1);
                    });
                  },
                );
              },
            );
          },
          child: _buildMenu(
            <Widget>[
              Text(
                DateFormat.yMMMd().add_jm().format(date),
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
              _buildDateAndTimePicker(context, proposedDate1),
              _buildDateAndTimePicker(context, proposedDate2),
              _buildDateAndTimePicker(context, proposedDate3),
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
              _buildDateAndTimePicker(context, proposedDate1),
              _buildDateAndTimePicker(context, proposedDate2),
              _buildDateAndTimePicker(context, proposedDate3),
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
