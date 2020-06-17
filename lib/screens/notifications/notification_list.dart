import 'package:canteen_frontend/screens/notifications/notification_item.dart';
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
    print('NOTIFICATION LIST');
    print(widget.notifications.map((n) => n.lastUpdated));

    return ListView.builder(
        itemCount: widget.notifications.length,
        itemBuilder: (BuildContext context, int index) {
          final notification = widget.notifications[index]
              as CanteenNotification.DetailedNotification;

          if (index == 0) {
            print('${notification.id}');
            print('NOTIFICATION ITEM 0: ${notification.read}');
            print('${notification.lastUpdated}');
          }

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
          );
        });
  }
}
