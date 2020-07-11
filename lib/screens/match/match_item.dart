import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class MatchItem extends StatelessWidget {
  final String displayName;
  final String photoUrl;
  final String message;
  final DateTime time;
  final GestureTapCallback onTap;

  MatchItem({
    Key key,
    this.displayName = '',
    this.photoUrl = '',
    this.message = '',
    @required this.time,
    @required this.onTap,
  }) : super(key: key);

  String formatTime(DateTime time) {
    String t = timeago
        .format(time, locale: 'en_short')
        .replaceFirst(' ', '')
        .replaceFirst('~', '')
        .replaceFirst('min', 'm');

    return t == 'now' ? t : '$t ago';
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
              border: Border(
                top:
                    BorderSide(width: 0.5, color: Palette.borderSeparatorColor),
              ),
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
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      displayName,
                                      textAlign: TextAlign.start,
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                    Text(
                                      formatTime(
                                        time,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: constraints.maxHeight * 0.07,
                                ),
                                child: Text(
                                  message,
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
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
