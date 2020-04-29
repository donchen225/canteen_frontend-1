import 'package:canteen_frontend/screens/profile/availability_picker.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditAvailabilityScreen extends StatefulWidget {
  final String fieldName;
  final DateTime startTime;
  final DateTime endTime;
  final Function onComplete;
  final Function onCancelNavigation;
  final Function onCompleteNavigation;

  EditAvailabilityScreen({
    @required this.fieldName,
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

  @override
  void initState() {
    super.initState();

    startTime = widget.startTime ?? DateTime.fromMillisecondsSinceEpoch(0);
    endTime = widget.endTime ?? DateTime.fromMillisecondsSinceEpoch(0);
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
                  widget.onComplete(startTime, endTime);
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
          height: MediaQuery.of(context).size.height * 0.25,
          padding: EdgeInsets.only(
              top: SizeConfig.instance.blockSizeVertical * 6,
              left: SizeConfig.instance.blockSizeHorizontal * 6,
              right: SizeConfig.instance.blockSizeHorizontal * 6,
              bottom: SizeConfig.instance.blockSizeVertical * 6),
          child: Row(
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
                      endTime = newTime;
                    });
                  }),
                ],
              )
            ],
          )),
    );
  }
}
