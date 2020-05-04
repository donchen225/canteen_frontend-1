import 'package:canteen_frontend/models/availability/availability.dart';
import 'package:canteen_frontend/models/availability/day.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class AvailabilitySection extends StatelessWidget {
  final Availability availability;
  final Function onDayTap;
  final Map<String, Day> days = {
    'MON': Day.monday,
    'TUE': Day.tuesday,
    'WED': Day.wednesday,
    'THU': Day.thursday,
    'FRI': Day.friday,
    'SAT': Day.saturday,
    'SUN': Day.sunday,
  };

  AvailabilitySection({this.availability, this.onDayTap});

  Widget _buildDayWidget(BuildContext context, MapEntry<String, Day> day) {
    int startTimeSeconds;
    int endTimeSeconds;

    final dayIndex = day.value.index.toString();
    if (availability != null &&
        availability.timeRangeRaw.containsKey(dayIndex)) {
      startTimeSeconds = availability.timeRangeRaw[dayIndex]['start_time'];
      endTimeSeconds = availability.timeRangeRaw[dayIndex]['end_time'];
    }

    final startTime = startTimeSeconds != null
        ? TimeOfDay.fromDateTime(
            DateTime.fromMillisecondsSinceEpoch(startTimeSeconds * 1000))
        : null;
    final endTime = endTimeSeconds != null
        ? TimeOfDay.fromDateTime(
            DateTime.fromMillisecondsSinceEpoch(endTimeSeconds * 1000))
        : null;

    return GestureDetector(
      onTap: () {
        if (onDayTap != null) {
          onDayTap(day.value);
        }
      },
      child: Container(
        height: SizeConfig.instance.blockSizeVertical * 10,
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.instance.blockSizeHorizontal * 3),
        decoration: BoxDecoration(
          border: Border.all(width: 1),
        ),
        child: Row(
          children: <Widget>[
            Expanded(child: Text(day.key)),
            Expanded(
                flex: 3,
                child: Visibility(
                    visible: startTime != null && endTime != null,
                    child: Row(
                      children: <Widget>[
                        Text(startTime?.format(context) ?? ''),
                        Text('-'),
                        Text(endTime?.format(context) ?? ''),
                      ],
                    ))),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.instance.blockSizeHorizontal * 3),
      child: Column(
        children: days.entries
            .map<Widget>((day) => _buildDayWidget(context, day))
            .toList(),
      ),
    );
  }
}
