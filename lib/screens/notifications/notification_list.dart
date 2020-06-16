import 'package:canteen_frontend/screens/notifications/notification_item.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:canteen_frontend/models/notification/notification.dart'
    as CanteenNotification;

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
            name: notification.user.displayName,
            photoUrl: notification.user.photoUrl,
            type: notification.object,
            time: notification.lastUpdated,
            onTap: () {},
          );
        });
  }
}
