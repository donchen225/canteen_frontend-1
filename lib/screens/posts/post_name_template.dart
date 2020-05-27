import 'package:canteen_frontend/utils/size_config.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';

class PostNameTemplate extends StatelessWidget {
  final String name;
  final String title;
  final String photoUrl;
  final DateTime time;
  final Color color;

  PostNameTemplate(
      {@required this.name,
      @required this.title,
      @required this.photoUrl,
      @required this.time,
      this.color = const Color(0xFF9E9E9E)});

  String formatTime(DateTime time) {
    String t = timeago
        .format(time, locale: 'en_short')
        .replaceFirst(' ', '')
        .replaceFirst('~', '')
        .replaceFirst('min', 'm');

    return t;
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText1;

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              name ?? '',
              style: textStyle.apply(fontWeightDelta: 1),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.instance.blockSizeHorizontal),
              child: Container(
                width: SizeConfig.instance.blockSizeHorizontal,
                height: SizeConfig.instance.blockSizeHorizontal,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Text(
              formatTime(time),
              style: textStyle.apply(color: color),
            ),
          ],
        ),
        Visibility(
          visible: title?.isNotEmpty ?? false,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title ?? '',
              style: textStyle.apply(color: color),
            ),
          ),
        ),
      ],
    );
  }
}
