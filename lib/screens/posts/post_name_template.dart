import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';

class PostNameTemplate extends StatelessWidget {
  final String name;
  final String photoUrl;
  final DateTime time;
  final Color color;

  PostNameTemplate(
      {@required this.name,
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
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            right: SizeConfig.instance.blockSizeHorizontal * 2,
          ),
          child: ProfilePicture(
            photoUrl: photoUrl,
            editable: false,
            size: SizeConfig.instance.blockSizeHorizontal * 6,
          ),
        ),
        Text(
          name ?? '',
          style: TextStyle(color: color),
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
          style: TextStyle(color: color, fontSize: 12),
        ),
      ],
    );
  }
}
