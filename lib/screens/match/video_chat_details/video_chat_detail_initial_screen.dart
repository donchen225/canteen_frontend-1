import 'package:canteen_frontend/models/availability/day.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/models/match/match.dart';
import 'package:canteen_frontend/models/video_chat_date/video_chat_date.dart';
import 'package:canteen_frontend/screens/match/match_detail_bloc/bloc.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tuple/tuple.dart';

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
  final f = DateFormat('yMMMMd');
  Map<DateTime, List> _events;
  CalendarController _calendarController;
  List<DateTime> _availableTimes;
  final DateTime now = DateTime.now();
  DateTime startDate;
  DateTime endDate;
  final availableDateRange = 60;
  final markerSize = 35.0;
  final duration = 30;
  Map<Day, List<Tuple2<int, int>>> localTimeRanges;

  @override
  void initState() {
    super.initState();

    print('MATCH DETAIL TIME SELECTION SCREEN');
    localTimeRanges = widget.user.availability.timeRangesLocal;
    print(localTimeRanges);

    _availableTimes = [];
    initializeEvents();
    _calendarController = CalendarController();
    // TODO: debug why I can't set selected day here, problem in library
    // _calendarController.setSelectedDay(now);
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void initializeEvents() {
    _events = {};
    startDate = DateTime(now.year, now.month, now.day);
    endDate = startDate.add(Duration(days: availableDateRange));

    final availableDays = localTimeRanges.keys.map((day) => day.index);

    for (var i = 0; i < availableDateRange; i++) {
      final date = startDate.add(Duration(days: i));
      final dayIndex = date.weekday - 1;

      if (availableDays.contains(dayIndex)) {
        _events[date] = [];
        localTimeRanges[Day.values[dayIndex]].forEach((timeRange) {
          final diff = timeRange.item2 - timeRange.item1;
          final numTimes = diff ~/ (duration * 60);
          final times = List<DateTime>.generate(
              numTimes,
              (int index) => DateTime.fromMillisecondsSinceEpoch(
                  (timeRange.item1 + (duration * 60 * index)) * 1000,
                  isUtc: true));

          _events[date].addAll(times);
        });
      }
    }
  }

  Widget _buildDay(DateTime day) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.center,
        width: markerSize,
        height: markerSize,
        child: Text(
          day.day.toString(),
          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSelectedDay(DateTime day) {
    return Container(
      alignment: Alignment.center,
      width: markerSize,
      height: markerSize,
      decoration: BoxDecoration(
        color: Colors.orange,
        shape: BoxShape.circle,
        borderRadius: null,
      ),
      child: Text(
        day.day.toString(),
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildToday(DateTime day) {
    return Stack(children: <Widget>[
      Align(
        alignment: Alignment.center,
        child: Container(
          alignment: Alignment.center,
          width: markerSize,
          height: markerSize,
          child: Text(
            day.day.toString(),
            style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      Align(
        alignment: Alignment.center,
        child: Container(
          width: markerSize / 1.3,
          height: markerSize / 1.3,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 5,
              height: 5,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
            ),
          ),
        ),
      )
    ]);
  }

  Widget _buildDow(String day) {
    return Container(
      alignment: Alignment.center,
      child: Text(day),
    );
  }

  Widget _buildEventsMarker() {
    return Container(
      width: markerSize,
      height: markerSize,
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        shape: BoxShape.circle,
        borderRadius: null,
      ),
    );
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
      startingDayOfWeek: StartingDayOfWeek.monday,
      startDay: now,
      initialSelectedDay: now,
      endDay: endDate,
      rowHeight: SizeConfig.instance.blockSizeVertical * 6,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.deepOrange[400],
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
      initialCalendarFormat: CalendarFormat.month,
      availableCalendarFormats: {
        CalendarFormat.month: 'Month',
      },
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, events) {
          return _buildSelectedDay(date);
        },
        dayBuilder: (context, date, events) {
          return _buildDay(date);
        },
        dowWeekendBuilder: (context, day) {
          return _buildDow(day);
        },
        dowWeekdayBuilder: (context, day) {
          return _buildDow(day);
        },
        todayDayBuilder: (context, date, events) {
          return _buildToday(date);
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(Align(
              child: _buildEventsMarker(),
            ));
          }

          return children;
        },
      ),

      onDaySelected: _onDaySelected,
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
                  title: Align(
                      alignment: Alignment.center,
                      child: Text(DateFormat.jm().format(event))),
                  // Go to payment page
                  onTap: () {
                    BlocProvider.of<MatchDetailBloc>(context)
                        .add(SelectVideoChatDate(
                      matchId: widget.match.id,
                      videoChatId: widget.match.activeVideoChat,
                      date: VideoChatDate(
                          userId: widget.user.id,
                          startTime: event,
                          duration: 30,
                          timeZone: event.timeZoneName),
                    ));
                  },
                ),
              ))
          .toList(),
    );
  }

  void _onDaySelected(DateTime day, List events) {
    setState(() {
      _availableTimes = events.map<DateTime>((x) => x).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Align(
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
          Container(
            child: _buildTableCalendar(),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              f.format(_calendarController.selectedDay ?? now),
            ), // TODO: remove now
          ),
          Expanded(
            flex: 1,
            child: _buildEventList(),
          ),
        ],
      ),
    );
  }
}
