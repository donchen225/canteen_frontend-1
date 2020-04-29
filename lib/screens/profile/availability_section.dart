import 'package:canteen_frontend/models/availability/day.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class AvailabilitySection extends StatelessWidget {
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

  AvailabilitySection({this.onDayTap});

  Widget _buildDayWidget(MapEntry<String, Day> day) {
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
          children: <Widget>[Text(day.key)],
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
        children: days.entries.map<Widget>(_buildDayWidget).toList(),
      ),
    );
  }
}
