import 'package:canteen_frontend/models/availability/day.dart';
import 'package:canteen_frontend/screens/profile/availability_picker.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';

class EditAvailabilityScreen extends StatefulWidget {
  final String fieldName;
  final Day day;
  final DateTime startTime;
  final DateTime endTime;
  final Function onComplete;
  final Function onCancelNavigation;
  final Function onCompleteNavigation;

  EditAvailabilityScreen({
    @required this.fieldName,
    @required this.day,
    @required this.onComplete,
    @required this.onCancelNavigation,
    @required this.onCompleteNavigation,
    this.startTime,
    this.endTime,
  });

  @override
  _EditAvailabilityScreenState createState() => _EditAvailabilityScreenState();
}

class _EditAvailabilityScreenState extends State<EditAvailabilityScreen> {
  _EditAvailabilityScreenState();
  DateTime startTime;
  DateTime endTime;
  String _errorText;

  @override
  void initState() {
    super.initState();

    startTime = widget.startTime ?? DateTime.fromMillisecondsSinceEpoch(0);
    endTime = widget.endTime ?? DateTime.fromMillisecondsSinceEpoch(0);
    _errorText = '';
  }

  Widget _buildMenu(Widget child) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey[400]),
      ),
      height: SizeConfig.instance.blockSizeVertical * 6,
      width: SizeConfig.instance.blockSizeHorizontal * 30,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SafeArea(top: false, bottom: false, child: child),
      ),
    );
  }

  Widget _buildTimePicker(
      BuildContext context, DateTime time, Function onTimeChange) {
    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) {
            return AvailabilityPicker(
              initialTime: time,
              onChanged: (dateTime) {
                onTimeChange(dateTime);
              },
            );
          },
        );
      },
      child: _buildMenu(
        Text(DateFormat.jm().format(time)),
      ),
    );
  }

  List<Tuple3<Day, int, int>> _getStartTimeAndDuration(
      Day day, DateTime startTime, DateTime endTime) {
    final startTimeLocal = startTime.toLocal();
    final startTimeUtc = startTime.toUtc();

    final endTimeLocal = endTime.toLocal();
    final endTimeUtc = endTime.toUtc();

    final startTimeUtcSeconds =
        (startTimeUtc.hour * 60 + startTimeUtc.minute) * 60;
    final endTimeUtcSeconds = (endTimeUtc.hour * 60 + endTimeUtc.minute) * 60;
    final duration = endTimeUtcSeconds - startTimeUtcSeconds;

    if (startTimeUtc.weekday == endTimeUtc.weekday) {
      print('SAME UTC WEEKDAY');
      if (startTimeLocal.weekday == startTimeUtc.weekday) {
        return [Tuple3(day, startTimeUtcSeconds, duration)];
      } else if (startTimeLocal.weekday < startTimeUtc.weekday) {
        final newDay = Day.values[day.index + 1 <= 6 ? day.index + 1 : 0];
        return [Tuple3(newDay, startTimeUtcSeconds, duration)];
      } else {
        final newDay = Day.values[day.index - 1 >= 0 ? day.index - 1 : 6];
        return [Tuple3(newDay, startTimeUtcSeconds, duration)];
      }
    } else if (startTimeUtc.weekday < endTimeUtc.weekday) {
      print('SEPARATE UTC DAYS');
      if (startTimeLocal.weekday == startTimeUtc.weekday) {
        final totalSeconds = 24 * 60 * 60;
        final newDay = Day.values[day.index + 1 <= 6 ? day.index + 1 : 0];
        return [
          Tuple3(day, startTimeUtcSeconds, totalSeconds - startTimeUtcSeconds),
          Tuple3(newDay, 0, endTimeUtcSeconds)
        ];
      } else if (endTimeLocal.weekday == endTimeUtc.weekday) {
        final totalSeconds = 24 * 60 * 60;
        final newDay = Day.values[day.index - 1 >= 0 ? day.index - 1 : 6];
        return [
          Tuple3(
              newDay, startTimeUtcSeconds, totalSeconds - startTimeUtcSeconds),
          Tuple3(day, 0, endTimeUtcSeconds)
        ];
      } else {
        print('ERROR CONVERTING LOCAL TIME TO UTC TIME');
      }
    } else {
      print('ERROR CONVERTING LOCAL TIME TO UTC TIME');
    }

    if (startTimeLocal.weekday == startTimeUtc.weekday &&
        endTimeLocal.weekday == endTimeUtc.weekday) {
      print('SAME');
      print('WEEKDAY: ${widget.day}');
      return [Tuple3(day, startTimeUtcSeconds, duration)];
    } else if (startTimeLocal.weekday < startTimeUtc.weekday &&
        endTimeLocal.weekday < endTimeUtc.weekday) {
      print('BEFORE');
      final newDay =
          Day.values[widget.day.index + 1 <= 6 ? widget.day.index + 1 : 0];
      print('WEEKDAY: $newDay');
      return [Tuple3(newDay, startTimeUtcSeconds, duration)];
    } else if (startTimeLocal.weekday < startTimeUtc.weekday &&
        endTimeLocal.weekday == endTimeUtc.weekday) {
      print('BEFORE');
      final newDay =
          Day.values[widget.day.index + 1 <= 6 ? widget.day.index + 1 : 0];
      print('WEEKDAY: $newDay');
      return [
        Tuple3(newDay, startTimeUtcSeconds, duration),
        Tuple3(newDay, startTimeUtcSeconds, duration)
      ];
    } else if (startTimeLocal.weekday > startTimeUtc.weekday &&
        endTimeLocal.weekday > endTimeUtc.weekday) {
      print('AFTER');
      final newDay =
          Day.values[widget.day.index - 1 >= 0 ? widget.day.index - 1 : 6];
      print('WEEKDAY: $newDay');
      return [Tuple3(newDay, startTimeUtcSeconds, duration)];
    } else if (startTimeLocal.weekday > startTimeUtc.weekday &&
        endTimeLocal.weekday == endTimeUtc.weekday) {
      print('AFTER');
      final newDay =
          Day.values[widget.day.index - 1 >= 0 ? widget.day.index - 1 : 6];
      print('WEEKDAY: $newDay');
      return [
        Tuple3(newDay, startTimeUtcSeconds, duration),
        Tuple3(newDay, startTimeUtcSeconds, duration)
      ];
    } else {
      print('ERROR CONVERTING LOCAL TIME TO UTC TIME');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
        backgroundColor: Palette.appBarBackgroundColor,
        elevation: 1,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                widget.onCancelNavigation();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 14,
                  color: Palette.orangeColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text('Edit ' + widget.fieldName),
            GestureDetector(
              onTap: () {
                if (startTime != widget.startTime &&
                    endTime != widget.endTime) {
                  if (endTime.isAfter(startTime)) {
                    final timeRanges = _getStartTimeAndDuration(
                        widget.day, startTime, endTime);
                    print('TIME RANGES: $timeRanges');
                    widget.onComplete(widget.day, startTime, endTime);
                  } else {
                    setState(() {
                      _errorText =
                          'Your end time cannot be before your start time.';
                    });
                  }
                } else {
                  widget.onCompleteNavigation();
                }
              },
              child: Text(
                'Done',
                style: TextStyle(
                  fontSize: 14,
                  color: Palette.orangeColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
          padding: EdgeInsets.only(
              top: SizeConfig.instance.blockSizeVertical * 6,
              left: SizeConfig.instance.blockSizeHorizontal * 6,
              right: SizeConfig.instance.blockSizeHorizontal * 6,
              bottom: SizeConfig.instance.blockSizeVertical * 6),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: SizeConfig.instance.blockSizeVertical),
                        child: Text(
                          'From',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      _buildTimePicker(context, startTime, (newTime) {
                        setState(() {
                          _errorText = '';
                          startTime = newTime;
                        });
                      }),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: SizeConfig.instance.blockSizeVertical),
                        child: Text(
                          'To',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      _buildTimePicker(context, endTime, (newTime) {
                        setState(() {
                          _errorText = '';
                          endTime = newTime;
                        });
                      }),
                    ],
                  )
                ],
              ),
              Visibility(
                visible: _errorText.isNotEmpty,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.instance.blockSizeVertical,
                  ),
                  child: Text(
                    _errorText,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
