import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeListSelector extends StatefulWidget {
  final DateTime day;
  final List<DateTime> times;
  final int duration;
  final Function onTapBack;

  TimeListSelector(
      {@required this.day,
      @required this.times,
      @required this.duration,
      @required this.onTapBack})
      : assert(day != null),
        assert(times != null),
        assert(duration != null),
        assert(onTapBack != null);

  @override
  _TimeListSelectorState createState() => _TimeListSelectorState();
}

class _TimeListSelectorState extends State<TimeListSelector> {
  final f = DateFormat('yMMMMd');
  List<DateTime> times;
  Color mainColor = Palette.orangeColor;

  @override
  void initState() {
    super.initState();

    times = widget.times ?? [];
  }

  Widget _buildTimeList() {
    return ListView(
      children: times
          .map((event) => Container(
                decoration: BoxDecoration(
                  border:
                      Border.all(width: 0.8, color: mainColor.withOpacity(0.7)),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Align(
                      alignment: Alignment.center,
                      child: Text(
                        DateFormat.jm().format(event),
                        style: TextStyle(
                            color: mainColor, fontWeight: FontWeight.bold),
                      )),
                  // Go to payment page
                  onTap: () {
                    // BlocProvider.of<MatchDetailBloc>(context).add(
                    //   SelectVideoChatDate(
                    //     matchId: widget.match.id,
                    //     videoChatId: widget.match.activeVideoChat,
                    //     skill: widget.skill,
                    //     date: VideoChatDate(
                    //         userId: widget.user.id,
                    //         startTime: event,
                    //         duration: eventDuration,
                    //         timeZone: event.timeZoneName),
                    //   ),
                    // );
                  },
                ),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline6;

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            bottom: SizeConfig.instance.safeBlockVertical * 2,
          ),
          child: Row(
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
                    child: Text(
                      f.format(widget.day),
                      style: titleStyle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.instance.safeBlockVertical * 2,
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
        ),
        Expanded(
          flex: 1,
          child: _buildTimeList(),
        ),
      ],
    );
  }
}
