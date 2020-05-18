import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeListSelector extends StatefulWidget {
  final DateTime day;
  final List<DateTime> times;
  final int duration;
  final Function onTapBack;
  final Function onTap;

  TimeListSelector(
      {@required this.day,
      @required this.times,
      @required this.duration,
      @required this.onTapBack,
      @required this.onTap})
      : assert(day != null),
        assert(times != null),
        assert(duration != null),
        assert(onTapBack != null),
        assert(onTap != null);

  @override
  _TimeListSelectorState createState() => _TimeListSelectorState();
}

class _TimeListSelectorState extends State<TimeListSelector> {
  final now = DateTime.now();
  final dateFormat = DateFormat('yMMMMd');
  final weekdayFormat = DateFormat('EEEE');
  List<DateTime> times;
  Color mainColor = Palette.orangeColor;
  DateTime selectedTime;

  @override
  void initState() {
    super.initState();

    times = widget.times ?? [];
  }

  Widget _buildTimeList(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline6;

    return ListView(
      children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                top: SizeConfig.instance.safeBlockVertical * 2,
                bottom: SizeConfig.instance.safeBlockVertical,
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    'Select a Time',
                    style: titleStyle,
                  ),
                  Text('Duration: ${widget.duration.toString()} min'),
                ],
              ),
            )
          ] +
          times
              .map<Widget>((event) => Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.instance.safeBlockVertical,
                    ),
                    child: GestureDetector(
                      onTapDown: (_) {
                        setState(() {
                          selectedTime = event;
                        });
                      },
                      onTap: () => widget.onTap(event),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: event == selectedTime
                              ? mainColor
                              : Palette.containerColor,
                          border: Border.all(
                              width: 0.8, color: mainColor.withOpacity(0.7)),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            DateFormat.jm().format(event),
                            style: TextStyle(
                                color: event == selectedTime
                                    ? Palette.containerColor
                                    : mainColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ))
              .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline6;
    final subtitleStyle = Theme.of(context).textTheme.subtitle1;

    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: () => widget.onTapBack(),
              child: Icon(
                Icons.arrow_back_ios,
                size: 24,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 24),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Text(
                          weekdayFormat.format(widget.day),
                          style: titleStyle,
                        ),
                        Text(
                          dateFormat.format(widget.day),
                          style: subtitleStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.instance.safeBlockVertical * 2,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 0.5,
                      color: Palette.borderSeparatorColor,
                    ),
                  ),
                ),
                child: Text(
                  '${now.timeZoneName} Timezone (${DateFormat.jm().format(now)})',
                ),
              ),
            ),
          ],
        ),
        Expanded(
          flex: 1,
          child: Container(
            child: _buildTimeList(context),
          ),
        ),
      ],
    );
  }
}
