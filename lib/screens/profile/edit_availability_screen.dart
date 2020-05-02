import 'package:canteen_frontend/models/availability/day.dart';
import 'package:canteen_frontend/screens/profile/availability_picker.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  @override
  Widget build(BuildContext context) {
    // DateFormat format = new DateFormat("HH:mm:ss");
    // DateTime time = format.parse("3:00:00 PM", true);
    // DateTime time1 = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
    // print(time.toLocal());
    // print(time1);
    // print(time1.toLocal());
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
                          final localTime = startTime.toLocal();
                          final utcTime = startTime.toUtc();
                          print('START TIME: $startTime');
                          print('START TIME LOCAL: $localTime');
                          print(localTime.weekday);
                          print(localTime.day);
                          print('START TIME UTC: ${startTime.toUtc()}');
                          print(utcTime.weekday);
                          print(utcTime.day);

                          // If startTime and endTime both SAME weekday then use day of
                          // Else split to separate ranges with respective days
                          if (localTime.weekday == utcTime.weekday) {
                            print('SAME');
                          }

                          final daySeconds =
                              widget.day.index * (24 * 3600) * 1000;

                          var milliseconds =
                              ((utcTime.hour * 3600) + (utcTime.minute * 60)) *
                                  1000;
                          print(DateTime.fromMillisecondsSinceEpoch(
                              daySeconds + milliseconds,
                              isUtc: true));
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
