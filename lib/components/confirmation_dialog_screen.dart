import 'package:canteen_frontend/components/time_confirmation.dart';
import 'package:canteen_frontend/components/time_list_selector.dart';
import 'package:canteen_frontend/models/request/request_repository.dart';
import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/match/match_details_selection/calendar_date_time_selector.dart';
import 'package:canteen_frontend/screens/posts/action_button.dart';
import 'package:canteen_frontend/screens/posts/text_dialog_screen.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/screens/request/send_request_dialog/bloc/bloc.dart';
import 'package:canteen_frontend/screens/request/send_request_dialog/send_request_dialog.dart';
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
  TextEditingController _messageController;

  @override
  void initState() {
    super.initState();

    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Widget _buildTimeSelectorWidget() {
    if (widget.user.availability == null ||
        widget.user.availability.timeRangeRaw.isEmpty) {
      return Column(
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              '${widget.user.displayName} has not set their availability.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: SizeConfig.instance.safeBlockVertical * 2,
              bottom: SizeConfig.instance.safeBlockVertical,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
                'However, you can still send ${widget.user.displayName} a request. Requests sent with messages have higher response rates.'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: SizeConfig.instance.safeBlockVertical,
            ),
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              autofocus: false,
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[500], width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[500], width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[500], width: 1.0),
                ),
                hintText: 'Add a message',
              ),
            ),
          ),
        ],
      );
    } else if (_timeList == null || _timeList.length == 0) {
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
      sendWidget: ActionButton(
          text: 'Send',
          enabled: _selectedTime != null ||
              (widget.user.availability == null ||
                  widget.user.availability.timeRangeRaw.isEmpty),
          onTap: (BuildContext context) async {
            if (_selectedTime != null ||
                (widget.user.availability == null ||
                    widget.user.availability.timeRangeRaw.isEmpty)) {
              if (widget.onConfirm != null) {
                widget.onConfirm(_message, _selectedTime);
                await showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) => BlocProvider.value(
                    value: BlocProvider.of<SendRequestBloc>(context),
                    child: SendRequestDialog(),
                  ),
                );
              }
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
                          style: subTitleStyle.apply(
                              color: Palette.textSecondaryBaseColor),
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
                    style: titleStyle,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: SizeConfig.instance.safeBlockVertical,
                  ),
                  child: Text(
                    widget.skill.description,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Text(
                  '\$${(widget.skill.price).toString()}' +
                      (widget.skill.duration != null
                          ? ' / ${widget.skill.duration} minutes'
                          : ''),
                  style: Theme.of(context).textTheme.bodyText1,
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
