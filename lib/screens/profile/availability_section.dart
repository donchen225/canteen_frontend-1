import 'package:canteen_frontend/models/availability/availability.dart';
import 'package:canteen_frontend/models/availability/day.dart';
import 'package:canteen_frontend/screens/profile/profile_text_card.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class AvailabilitySection extends StatelessWidget {
  final Availability availability;
  final Function onDayTap;
  final Map<String, Day> days = {
    'Mondays': Day.monday,
    'Tuesdays': Day.tuesday,
    'Wednesdays': Day.wednesday,
    'Thursdays': Day.thursday,
    'Fridays': Day.friday,
    'Saturdays': Day.saturday,
    'Sundays': Day.sunday,
  };

  AvailabilitySection({this.availability, this.onDayTap});

  Border _buildBorder(Day day) {
    return day == Day.sunday
        ? Border()
        : Border(
            bottom: BorderSide(
              width: 0.5,
              color: Colors.grey[400],
            ),
          );
  }

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
        ? TimeOfDay.fromDateTime(DateTime.fromMillisecondsSinceEpoch(
            startTimeSeconds * 1000,
            isUtc: true))
        : null;
    final endTime = endTimeSeconds != null
        ? TimeOfDay.fromDateTime(DateTime.fromMillisecondsSinceEpoch(
            endTimeSeconds * 1000,
            isUtc: true))
        : null;

    return GestureDetector(
      onTap: () {
        if (onDayTap != null) {
          onDayTap(day.value, startTime, endTime);
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          left: SizeConfig.instance.safeBlockHorizontal * 3,
          right: SizeConfig.instance.safeBlockHorizontal * 3,
          top: SizeConfig.instance.safeBlockVertical * 2,
          bottom: SizeConfig.instance.safeBlockVertical * 2,
        ),
        decoration: BoxDecoration(
          border: _buildBorder(day.value),
        ),
        child: Row(
          children: <Widget>[
            Expanded(child: Text(day.key)),
            Expanded(
                child: Visibility(
                    visible: startTime != null && endTime != null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
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
    return ProfileTextCard(
      child: Column(
        children: days.entries
            .map<Widget>((day) => _buildDayWidget(context, day))
            .toList(),
      ),
    );
  }
}
