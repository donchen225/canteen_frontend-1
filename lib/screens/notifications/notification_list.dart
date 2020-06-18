import 'package:canteen_frontend/screens/notifications/bloc/bloc.dart';
import 'package:canteen_frontend/screens/notifications/notification_item.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:canteen_frontend/models/notification/notification.dart'
    as CanteenNotification;
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationList extends StatefulWidget {
  final List<CanteenNotification.Notification> notifications;

  NotificationList({this.notifications});

  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.notifications.length,
        itemBuilder: (BuildContext context, int index) {
          final notification = widget.notifications[index]
              as CanteenNotification.DetailedNotification;

          return NotificationItem(
            key: Key(notification.id),
            name: notification.user.displayName,
            photoUrl: notification.user.photoUrl,
            type: notification.object,
            count: notification.count,
            time: notification.lastUpdated,
            targetId: notification.targetId,
            parentId: notification.parentId,
            data: notification.data,
            read: notification.read,
            notificationId: notification.id,
            onCreated: () {
              if (index != 0 && index % (postsPerPage - 1) == 0) {
                final page = index ~/ (postsPerPage - 1);
                BlocProvider.of<NotificationListBloc>(context)
                    .add(LoadOldNotifications(page: page));
              }
            },
          );
        });
  }
}
