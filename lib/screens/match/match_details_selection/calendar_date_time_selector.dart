import 'package:canteen_frontend/models/availability/day.dart';
import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tuple/tuple.dart';

class CalendarDateTimeSelector extends StatefulWidget {
  final User user;
  final Skill skill;
  final double height;
  final Function onDaySelected;

  CalendarDateTimeSelector({
    @required this.user,
    @required this.skill,
    this.height = 400,
    this.onDaySelected,
  });

  @override
  _CalendarDateTimeSelectorState createState() =>
      _CalendarDateTimeSelectorState();
}

class _CalendarDateTimeSelectorState extends State<CalendarDateTimeSelector> {
  final f = DateFormat('yMMMMd');
  Map<DateTime, List> _events;
  CalendarController _calendarController;
  final DateTime now = DateTime.now();
  DateTime startDate;
  DateTime endDate;
  final availableDateRange = 60;
  double markerSize = 35.0;
  int eventDuration;
  int eventDiff = 30;
  final Color mainColor = Colors.orange;
  Map<Day, List<Tuple2<int, int>>> localTimeRanges;

  @override
  void initState() {
    super.initState();

    print('INIT CALENDAR STATE');

    startDate = DateTime(now.year, now.month, now.day);
    endDate = startDate.add(Duration(days: availableDateRange));

    localTimeRanges = widget.user.availability?.timeRangesLocal ?? {};
    eventDuration = widget.skill.duration;
    initializeEvents();

    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void initializeEvents() {
    _events = {};

    final availableDays = localTimeRanges.keys.map((day) => day.index);

    for (var i = 0; i < availableDateRange; i++) {
      final date = startDate.add(Duration(days: i));
      final dayIndex = date.weekday - 1;

      if (availableDays.contains(dayIndex)) {
        _events[date] = [];
        localTimeRanges[Day.values[dayIndex]].forEach((timeRange) {
          final diff = timeRange.item2 - timeRange.item1 - (eventDuration * 60);

          if (diff >= 0) {
            final numTimes = (diff ~/ (eventDiff * 60)) + 1;
            final times = List<DateTime>.generate(
              numTimes,
              (int index) => date.add(
                Duration(
                  seconds: timeRange.item1 + (eventDiff * 60 * index),
                ),
              ),
            );

            _events[date].addAll(times);
          }
        });
      }
    }
  }

  Widget _buildDay(DateTime day) {
    markerSize = widget.height * 0.11;

    return Align(
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.center,
        width: markerSize,
        height: markerSize,
        child: Text(
          day.day.toString(),
          style: TextStyle(color: mainColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSelectedDay(DateTime day) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.center,
        width: markerSize,
        height: markerSize,
        decoration: BoxDecoration(
          color: mainColor,
          shape: BoxShape.circle,
          borderRadius: null,
        ),
        child: Text(
          day.day.toString(),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
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
            style: TextStyle(color: mainColor, fontWeight: FontWeight.bold),
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
        color: mainColor.withOpacity(0.1),
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
      initialSelectedDay: null,
      endDay: endDate,
      rowHeight: widget.height * 0.12,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.deepOrange[400],
        markersColor: Colors.brown[700],
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        headerPadding: EdgeInsets.symmetric(vertical: 0),
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
    );
  }

  void _onDaySelected(DateTime day, List events) {
    if (widget.onDaySelected != null) {
      widget.onDaySelected(events.map<DateTime>((x) => x).toList(), day);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.containerColor,
      height: widget.height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Text('Select a Day',
                style: Theme.of(context).textTheme.headline6),
          ),
          Container(
            child: _buildTableCalendar(),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.instance.blockSizeHorizontal * 6),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      bottom: SizeConfig.instance.blockSizeVertical),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '*${now.timeZoneName} Timezone (${DateFormat.jm().format(now)})',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
