import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/models/match/match.dart';
import 'package:canteen_frontend/models/video_chat_date/proposed_date_time.dart';
import 'package:canteen_frontend/models/video_chat_date/video_chat_date.dart';
import 'package:canteen_frontend/utils/date_utils.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'video_chat_details_selection_screen.dart';

class VideoChatDetailScreen extends StatefulWidget {
  final User user;
  final Match match;
  final List<VideoChatDate> userDates;
  final List<VideoChatDate> partnerDates;

  VideoChatDetailScreen(
      {@required this.user,
      @required this.match,
      this.userDates,
      this.partnerDates})
      : assert(user != null);

  _VideoChatDetailScreenState createState() => _VideoChatDetailScreenState();
}

class _VideoChatDetailScreenState extends State<VideoChatDetailScreen> {
  String videoChatUrl;

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
              VideoChatDetailsSelectionBlock(
                  user: widget.user,
                  onSubmit: (List<VideoChatDate> proposedDates) {
                    // BlocProvider.of<VideoChatDetailsBloc>(context).add(
                    //   ProposeVideoChatDates(
                    //     matchId: widget.match.id,
                    //     videoChatId: widget.match.activeVideoChat,
                    //     dates: proposedDates,
                    //   ),
                    // );
                  }),
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
