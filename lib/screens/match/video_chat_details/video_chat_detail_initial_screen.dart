import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/models/match/match.dart';
import 'package:canteen_frontend/models/video_chat_date/video_chat_date.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'video_chat_details_selection_screen.dart';

class VideoChatDetailInitialScreen extends StatefulWidget {
  final User user;
  final Match match;

  VideoChatDetailInitialScreen({
    @required this.user,
    @required this.match,
  });

  @override
  _VideoChatDetailInitialScreenState createState() =>
      _VideoChatDetailInitialScreenState();
}

class _VideoChatDetailInitialScreenState
    extends State<VideoChatDetailInitialScreen> {
  MaterialLocalizations localizations;
  CalendarController _calendarController;
  List _availableTimes;

  @override
  void initState() {
    super.initState();

    _availableTimes = ['9:00am', '10:00am', '11:00am'];

    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  Iterable<TimeOfDay> getTimes(
      TimeOfDay startTime, TimeOfDay endTime, Duration step) sync* {
    var hour = startTime.hour;
    var minute = startTime.minute;

    do {
      yield TimeOfDay(hour: hour, minute: minute);
      minute += step.inMinutes;
      while (minute >= 60) {
        minute -= 60;
        hour++;
      }
    } while (hour < endTime.hour ||
        (hour == endTime.hour && minute <= endTime.minute));
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.deepOrange[400],
        todayColor: Colors.deepOrange[200],
        markersColor: Colors.brown[700],
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      // onDaySelected: _onDaySelected,
      // onVisibleDaysChanged: _onVisibleDaysChanged,
      // onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _availableTimes
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text(event.toString()),
                  onTap: () => print('$event tapped!'),
                ),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    localizations = MaterialLocalizations.of(context);
    _availableTimes = getTimes(TimeOfDay(hour: 0, minute: 0),
            TimeOfDay(hour: 24, minute: 0), Duration(minutes: 30))
        .map((x) => localizations.formatTimeOfDay(x))
        .toList();

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: SizeConfig.instance.blockSizeHorizontal * 3,
                      right: SizeConfig.instance.blockSizeHorizontal * 3,
                      top: SizeConfig.instance.blockSizeVertical * 3,
                    ),
                    child: Text(
                      'Select 3 times to video chat:',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _buildTableCalendar(),
                ),
                // Expanded(child: _buildEventList()),
                // VideoChatDetailsSelectionBlock(
                //     user: widget.user,
                //     onSubmit: (List<VideoChatDate> proposedDates) {
                //       // BlocProvider.of<VideoChatDetailsBloc>(context).add(
                //       //   ProposeVideoChatDates(
                //       //     matchId: matchId,
                //       //     videoChatId: videoChatId,
                //       //     dates: proposedDates,
                //       //   ),
                //       // );
                //     }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
