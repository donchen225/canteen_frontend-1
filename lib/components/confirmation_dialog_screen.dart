import 'package:canteen_frontend/components/time_confirmation.dart';
import 'package:canteen_frontend/components/time_list_selector.dart';
import 'package:canteen_frontend/models/request/request.dart';
import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/match/match_details_selection/calendar_date_time_selector.dart';
import 'package:canteen_frontend/screens/posts/post_button.dart';
import 'package:canteen_frontend/screens/posts/text_dialog_screen.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/screens/request/request_bloc/bloc.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfirmationDialogScreen extends StatefulWidget {
  final User user;
  final Skill skill;
  final double height;
  final Function onConfirm;

  ConfirmationDialogScreen(
      {@required this.user,
      @required this.skill,
      this.height = 500,
      @required this.onConfirm});

  @override
  _ConfirmationDialogScreenState createState() =>
      _ConfirmationDialogScreenState();
}

class _ConfirmationDialogScreenState extends State<ConfirmationDialogScreen> {
  List<DateTime> _timeList;
  DateTime _selectedDay;
  DateTime _selectedTime;
  String _message = '';

  _ConfirmationDialogScreenState();

  @override
  void initState() {
    super.initState();
  }

  Widget _buildTimeSelectorWidget() {
    if (_timeList == null || _timeList.length == 0) {
      return CalendarDateTimeSelector(
        user: widget.user,
        skill: widget.skill,
        onDaySelected: (List<DateTime> times, DateTime selectedDay) {
          setState(() {
            if (times.length > 0) {
              _timeList = times;
              _selectedDay = selectedDay;
            }
          });
        },
      );
    } else if (_timeList != null &&
        _selectedDay != null &&
        _selectedTime == null) {
      return TimeListSelector(
        day: _selectedDay,
        times: _timeList,
        duration: widget.skill.duration,
        onTapBack: () {
          setState(() {
            _timeList = null;
            _selectedDay = null;
          });
        },
        onTap: (DateTime time) {
          setState(() {
            _selectedTime = time;
          });
        },
      );
    } else if (_timeList != null &&
        _selectedDay != null &&
        _selectedTime != null) {
      return TimeConfirmation(
        time: _selectedTime,
        duration: widget.skill.duration,
        onMessageUpdated: (String message) {
          _message = message;
        },
        onTapBack: () {
          setState(() {
            _selectedTime = null;
          });
        },
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline6;
    final subTitleStyle = Theme.of(context).textTheme.subtitle1;

    return TextDialogScreen(
      title: 'Request Time',
      height: widget.height,
      sendWidget: PostButton(
          text: 'SEND',
          enabled: _selectedTime != null,
          onTap: (BuildContext context) {
            if (_selectedTime != null) {
              BlocProvider.of<RequestBloc>(context).add(
                AddRequest(
                  Request.create(
                    skill: widget.skill,
                    comment: _message,
                    time: _selectedTime,
                    receiverId: widget.user.id,
                  ),
                ),
              );

              Navigator.maybePop(context);
            } else {
              final snackBar = SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.white,
                duration: Duration(seconds: 2),
                content: Row(
                  children: <Widget>[
                    Container(
                      width: 10,
                      height: SizeConfig.instance.blockSizeVertical * 3,
                      color: Colors.red,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              SizeConfig.instance.blockSizeHorizontal * 3),
                      child: Text(
                        'Please select a time',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              );
              Scaffold.of(context).showSnackBar(snackBar);
            }
          }),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: widget.height * 0.1,
            child: Row(
              children: <Widget>[
                ProfilePicture(
                  photoUrl: widget.user.photoUrl,
                  editable: false,
                  size: widget.height * 0.1,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.instance.safeBlockHorizontal * 3,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${widget.user.displayName ?? ''}',
                          style: titleStyle,
                        ),
                        Text(
                          '${widget.user.title ?? ''}',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: subTitleStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: SizeConfig.instance.safeBlockVertical * 2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    bottom: SizeConfig.instance.safeBlockVertical,
                  ),
                  child: Text(
                    '${widget.skill.name ?? ''}',
                    style: subTitleStyle.apply(
                      fontWeightDelta: 2,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: SizeConfig.instance.safeBlockVertical,
                  ),
                  child: Text(widget.skill.description),
                ),
                Text(
                  '\$${(widget.skill.price).toString()}' +
                      (widget.skill.duration != null
                          ? ' / ${widget.skill.duration} minutes'
                          : ''),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: widget.height * 0.01),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 0.5,
                    color: Palette.borderSeparatorColor,
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    top: SizeConfig.instance.safeBlockVertical * 2),
                child: _buildTimeSelectorWidget(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
