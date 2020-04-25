import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/models/video_chat_date/proposed_date_time.dart';
import 'package:canteen_frontend/models/video_chat_date/video_chat_date.dart';
import 'package:canteen_frontend/screens/video_chat_details/video_chat_time_picker.dart';
import 'package:canteen_frontend/utils/date_utils.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VideoChatDetailScreen extends StatefulWidget {
  final User user;
  final List<VideoChatDate> userDates;
  final List<VideoChatDate> partnerDates;

  VideoChatDetailScreen(
      {@required this.user, this.userDates, this.partnerDates})
      : assert(user != null);

  _VideoChatDetailScreenState createState() => _VideoChatDetailScreenState();
}

class _VideoChatDetailScreenState extends State<VideoChatDetailScreen> {
  String videoChatUrl;

  final double _kPickerSheetHeight = 216.0;

  final int numDates = 3;
  DateTime now;
  DateTime initialDateTime;
  List<VideoChatDate> userDates;
  List<ProposedVieoChatDate> userProposedDates;
  List<VideoChatDate> partnerDates;

  @override
  void initState() {
    super.initState();

    now = DateTime.now();
    initialDateTime = roundUpHour(now, Duration(hours: 1));

    if (userDates == null) {
      userDates = List<VideoChatDate>.generate(
          numDates,
          (i) => VideoChatDate(
                userId: widget.user.id,
                startTime: initialDateTime,
                lastUpdated: now,
                status: 0,
              ));

      userProposedDates = List<ProposedVieoChatDate>.generate(userDates.length,
          (i) => ProposedVieoChatDate(userDates[i].startTime));
    }
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

  Widget _buildDateAndTimePicker(
      BuildContext context, ProposedVieoChatDate date) {
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
                      date.startTime = dateTime;
                    });
                  },
                );
              },
            );
          },
          child: _buildMenu(
            <Widget>[
              Text(
                DateFormat.yMMMd().add_jm().format(date.startTime),
              ),
            ],
          ),
        ),
      ],
    );
  }

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
              _buildDateAndTimePicker(context, userProposedDates[0]),
              _buildDateAndTimePicker(context, userProposedDates[1]),
              _buildDateAndTimePicker(context, userProposedDates[2]),
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
              // _buildDateAndTimePicker(context, proposedDate1),
              // _buildDateAndTimePicker(context, proposedDate2),
              // _buildDateAndTimePicker(context, proposedDate3),
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
