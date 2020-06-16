import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationItem extends StatelessWidget {
  final String name;
  final String photoUrl;
  final String type;
  final String data;
  final DateTime time;
  final GestureTapCallback onTap;

  NotificationItem({
    Key key,
    this.name = '',
    this.photoUrl = '',
    this.type = '',
    this.data = '',
    @required this.time,
    @required this.onTap,
  }) : super(key: key);

  String formatTime(DateTime time) {
    String t = timeago
        .format(time, locale: 'en_short')
        .replaceFirst(' ', '')
        .replaceFirst('~', '')
        .replaceFirst('min', 'm');

    return t == 'now' ? t : '$t';
  }

  String _generateMessage(String type) {
    if (type == 'like') {
      return 'liked your post.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: kMatchItemAspectRatio,
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            padding: EdgeInsets.only(
              top: constraints.maxHeight * 0.15,
              bottom: constraints.maxHeight * 0.15,
              left: constraints.maxWidth * 0.05,
              right: constraints.maxWidth * 0.03,
            ),
            decoration: BoxDecoration(
              color: Palette.containerColor,
              border: Border.all(width: 0.2, color: Colors.grey[400]),
            ),
            child: Stack(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    ProfilePicture(
                      photoUrl: photoUrl,
                      editable: false,
                      size: constraints.maxHeight * 0.7,
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(
                            left: constraints.maxWidth * 0.04,
                            right: constraints.maxWidth * 0.02),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: constraints.maxHeight * 0.03,
                              ),
                              child: RichText(
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.bodyText1,
                                  children: [
                                    TextSpan(
                                      text: '$name',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .apply(
                                            fontWeightDelta: 2,
                                          ),
                                    ),
                                    TextSpan(
                                        text:
                                            ' ${_generateMessage(type)} $data'),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                formatTime(time),
                                style:
                                    Theme.of(context).textTheme.bodyText2.apply(
                                          color: Palette.textSecondaryBaseColor,
                                        ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
