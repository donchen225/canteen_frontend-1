import 'package:canteen_frontend/screens/notifications/bloc/bloc.dart';
import 'package:canteen_frontend/screens/notifications/notification_single_post_screen.dart';
import 'package:canteen_frontend/screens/notifications/notification_view_bloc/bloc.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationItem extends StatefulWidget {
  final String name;
  final String photoUrl;
  final String type;
  final int count;
  final String data;
  final String targetId;
  final String parentId;
  final bool read;
  final DateTime time;

  NotificationItem({
    Key key,
    this.name = '',
    this.photoUrl = '',
    this.type = '',
    this.count = 0,
    this.data = '',
    this.read = false,
    this.targetId = '',
    this.parentId = '',
    @required this.time,
  }) : super(key: key);

  @override
  _NotificationItemState createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  bool _read;

  @override
  void initState() {
    super.initState();

    _read = widget.read;
  }

  String formatTime(DateTime time) {
    String t = timeago
        .format(time, locale: 'en_short')
        .replaceFirst(' ', '')
        .replaceFirst('~', '')
        .replaceFirst('min', 'm');

    return t == 'now' ? t : '$t';
  }

  String _generateMessage(String type, int count) {
    if (type == 'like' && count == 1) {
      return 'liked your post.';
    } else if (type == 'like' && count == 2) {
      return 'and 1 other liked your post.';
    } else if (type == 'like' && count > 2) {
      return 'and $count others liked your post.';
    }
  }

  void _onTap(BuildContext context, String type) {
    if (type == 'like') {
      BlocProvider.of<NotificationViewBloc>(context).add(LoadNotificationPost(
          postId: widget.targetId, groupId: widget.parentId));
      Navigator.pushNamed(context, NotificationSinglePostScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _onTap(context, widget.type);

        setState(() {
          _read = true;
        });
      },
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
              color: _read
                  ? Palette.containerColor
                  : Palette.unreadNotificationColor,
              border: Border.all(width: 0.2, color: Colors.grey[400]),
            ),
            child: Stack(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    ProfilePicture(
                      photoUrl: widget.photoUrl,
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
                                      text: '${widget.name}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .apply(
                                            fontWeightDelta: 2,
                                          ),
                                    ),
                                    TextSpan(
                                        text:
                                            ' ${_generateMessage(widget.type, widget.count)} ${widget.data}'),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                formatTime(widget.time),
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
