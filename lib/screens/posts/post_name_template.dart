import 'package:canteen_frontend/components/dot_spacer.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';

class PostNameTemplate extends StatelessWidget {
  final String name;
  final String title;
  final String photoUrl;
  final DateTime time;
  final Color color;
  final bool showDate;

  PostNameTemplate(
      {@required this.name,
      @required this.title,
      @required this.photoUrl,
      this.time,
      this.showDate = true,
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
    final titleTextStyle = Theme.of(context).textTheme.headline6;
    final secondaryTextStyle = Theme.of(context).textTheme.bodyText2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Flexible(
              child: Text(
                (name ?? '').replaceAll("", "\u{200B}"),
                style: titleTextStyle,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Visibility(
              visible: showDate,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.instance.blockSizeHorizontal),
                child: DotSpacer(),
              ),
            ),
            Visibility(
              visible: showDate,
              child: Text(
                time != null ? formatTime(time) : '',
                style: secondaryTextStyle.apply(color: color),
              ),
            ),
          ],
        ),
        Visibility(
          visible: title?.isNotEmpty ?? false,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title ?? '',
              style: secondaryTextStyle.apply(color: color),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
