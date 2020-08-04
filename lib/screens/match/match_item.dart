import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class MatchItem extends StatelessWidget {
  final String displayName;
  final String photoUrl;
  final String additionalDisplayName;
  final String additionalPhotoUrl;
  final String message;
  final DateTime time;
  final bool read;
  final GestureTapCallback onTap;

  MatchItem({
    Key key,
    this.displayName = '',
    this.photoUrl = '',
    this.additionalDisplayName = '',
    this.additionalPhotoUrl,
    this.message = '',
    this.read = true,
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

  String _buildTitle() {
    if (additionalDisplayName != null && additionalDisplayName.isNotEmpty) {
      return '$displayName ($additionalDisplayName)';
    } else {
      return displayName;
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
              top: constraints.maxHeight * 0.1,
              bottom: constraints.maxHeight * 0.1,
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
                      additionalPhotoUrl: additionalPhotoUrl,
                      editable: false,
                      size: constraints.maxHeight * 0.75,
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
                              flex: 2,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _buildTitle(),
                                      textAlign: TextAlign.start,
                                      style: read
                                          ? Theme.of(context)
                                              .textTheme
                                              .headline6
                                          : Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .apply(fontWeightDelta: 2),
                                    ),
                                    Text(
                                      formatTime(
                                        time,
                                      ),
                                      style: read
                                          ? Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .apply(fontSizeDelta: -1)
                                          : Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .apply(
                                                fontSizeDelta: -1,
                                                fontWeightDelta: 2,
                                              ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: Text(
                                      message,
                                      textAlign: TextAlign.start,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: read
                                          ? Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                          : Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .apply(fontWeightDelta: 2),
                                    ),
                                  ),
                                  Expanded(
                                    child: Visibility(
                                      visible: !read,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 3,
                                        ),
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
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
