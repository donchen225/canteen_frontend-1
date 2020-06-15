import 'package:canteen_frontend/components/confirm_button.dart';
import 'package:canteen_frontend/components/dialog_screen.dart';
import 'package:canteen_frontend/models/availability/day.dart';
import 'package:canteen_frontend/screens/profile/availability_picker.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditAvailabilityScreen extends StatefulWidget {
  final String fieldName;
  final Day day;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
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
  TimeOfDay startTime;
  TimeOfDay endTime;
  String _errorText;

  @override
  void initState() {
    super.initState();

    startTime = widget.startTime ?? TimeOfDay(hour: 9, minute: 0);
    endTime = widget.endTime ?? TimeOfDay(hour: 17, minute: 0);
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
      BuildContext context, TimeOfDay time, Function(TimeOfDay) onTimeChange) {
    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) {
            return AvailabilityPicker(
              initialTime: time,
              onChanged: (dateTime) {
                onTimeChange(TimeOfDay.fromDateTime(dateTime));
              },
            );
          },
        );
      },
      child: _buildMenu(
        Text(time.format(context)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DialogScreen(
      title: 'Edit ${widget.fieldName}',
      onCancel: () => widget.onCancelNavigation(),
      sendWidget: ConfirmButton(
        onTap: (BuildContext context) {
          if (startTime != widget.startTime || endTime != widget.endTime) {
            final startTimeSeconds =
                (startTime.hour * 60 + startTime.minute) * 60;
            final endTimeSeconds = !(endTime.hour == 0 && endTime.minute == 0)
                ? (endTime.hour * 60 + endTime.minute) * 60
                : 24 * 60 * 60;

            if (endTimeSeconds > startTimeSeconds) {
              widget.onComplete(widget.day, startTimeSeconds, endTimeSeconds);
            } else {
              setState(() {
                _errorText = 'Your end time cannot be before your start time.';
              });
            }
          } else {
            widget.onCompleteNavigation();
          }
        },
      ),
      child: Container(
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
