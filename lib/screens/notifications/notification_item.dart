import 'dart:async';

import 'package:canteen_frontend/screens/notifications/notification_single_post_screen.dart';
import 'package:canteen_frontend/screens/notifications/notification_view_bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/comment_list_bloc/bloc.dart';
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
  final String notificationId;
  final DateTime time;
  final Function onCreated;

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
    this.notificationId = '',
    this.time,
    this.onCreated,
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

    if (widget.onCreated != null) {
      widget.onCreated();
    }
  }

  String formatTime(DateTime time) {
    String t = timeago
        .format(time, locale: 'en_short')
        .replaceFirst(' ', '')
        .replaceFirst('~', '')
        .replaceFirst('min', 'm');

    return t == 'now' ? t : '$t';
  }

  String _generateMessage(String type, int count, String data) {
    if (type == 'like' && count == 1) {
      return 'liked your post.';
    } else if (type == 'like' && count == 2) {
      return 'and 1 other liked your post.';
    } else if (type == 'like' && count > 2) {
      return 'and ${count - 1} others liked your post.';
    } else if (type == 'comment' && count == 1) {
      return 'commented on your post: $data';
    } else if (type == 'comment' && count == 2) {
      return 'and 1 other commented on your post: $data';
    } else if (type == 'comment' && count > 2) {
      return 'and ${count - 1} others commented on your post: $data';
    }

    return '';
  }

  void _onTap(BuildContext context, String type) async {
    if (type == 'like' || type == 'comment') {
      BlocProvider.of<NotificationViewBloc>(context).add(LoadNotificationPost(
          postId: widget.targetId,
          groupId: widget.parentId,
          notificationId: widget.notificationId,
          read: widget.read));
      BlocProvider.of<CommentListBloc>(context).add(
          LoadCommentList(groupId: widget.parentId, postId: widget.targetId));
      Navigator.pushNamed<bool>(context, NotificationSinglePostScreen.routeName)
          .then((value) {
        Timer(
            Duration(milliseconds: 300),
            () => BlocProvider.of<NotificationViewBloc>(context)
                .add(ClearNotificationView()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bodyTextStyle = Theme.of(context).textTheme.bodyText2;

    return Material(
      key: widget.key,
      child: GestureDetector(
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
                top: constraints.maxHeight * 0.1,
                bottom: constraints.maxHeight * 0.1,
                left: constraints.maxWidth * 0.05,
                right: constraints.maxWidth * 0.03,
              ),
              decoration: BoxDecoration(
                color: _read
                    ? Palette.containerColor
                    : Palette.unreadNotificationColor,
                border: Border(
                  top: BorderSide(
                      width: 0.5, color: Palette.borderSeparatorColor),
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      ProfilePicture(
                        photoUrl: widget.photoUrl,
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: constraints.maxHeight * 0.02,
                                ),
                                child: RichText(
                                  textAlign: TextAlign.start,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    style: bodyTextStyle,
                                    children: [
                                      TextSpan(
                                        text: '${widget.name}',
                                        style: bodyTextStyle.apply(
                                          fontWeightDelta: 2,
                                        ),
                                      ),
                                      TextSpan(
                                          text:
                                              ' ${_generateMessage(widget.type, widget.count, widget.data)}'),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  formatTime(widget.time),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .apply(
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
      ),
    );
  }
}
