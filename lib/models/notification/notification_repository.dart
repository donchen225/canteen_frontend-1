import 'dart:async';

import 'package:canteen_frontend/models/notification/notification.dart';
import 'package:canteen_frontend/models/notification/notification_entity.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:tuple/tuple.dart';

class NotificationRepository {
  final notificationCollection = Firestore.instance.collection('notifications');
  final userNotificationCollection = 'notifications';
  final childNotificationCollection = 'child_notifications';

  NotificationRepository();

  Stream<Tuple2<List<Notification>, DocumentSnapshot>>
      getLatestNotifications() {
    final userId =
        CachedSharedPreferences.getString(PreferenceConstants.userId);

    Query query = notificationCollection
        .document(userId)
        .collection(userNotificationCollection)
        .orderBy("last_updated", descending: true)
        .limit(postsPerPage);

    return query.snapshots().map((querySnapshot) {
      return Tuple2<List<Notification>, DocumentSnapshot>(
          querySnapshot.documentChanges
              .map((doc) => Notification.fromEntity(
                  NotificationEntity.fromSnapshot(doc.document)))
              .toList(),
          querySnapshot.documents.isNotEmpty
              ? querySnapshot.documents.last
              : null);
    });
  }

  Future<Tuple2<List<Notification>, DocumentSnapshot>> getNotifications(
      {DocumentSnapshot startAfterDocument, int limit = 20}) {
    final userId =
        CachedSharedPreferences.getString(PreferenceConstants.userId);

    Query query = notificationCollection
        .document(userId)
        .collection(userNotificationCollection)
        .orderBy("last_updated", descending: true)
        .limit(limit);

    print('START AFTER: ${startAfterDocument.data}');
    if (startAfterDocument != null && startAfterDocument.exists) {
      query = query.startAfterDocument(startAfterDocument);
    }

    return query.getDocuments().then((querySnapshot) {
      return Tuple2<List<Notification>, DocumentSnapshot>(
          querySnapshot.documents
              .map((doc) =>
                  Notification.fromEntity(NotificationEntity.fromSnapshot(doc)))
              .toList(),
          querySnapshot.documents.isNotEmpty
              ? querySnapshot.documents.last
              : null);
    }).catchError((error) {
      print('Error fetching notifications: $error');
      throw error;
    });
  }

  Future<void> readNotification(String notificationId) async {
    final userId =
        CachedSharedPreferences.getString(PreferenceConstants.userId);

    final notification = notificationCollection
        .document(userId)
        .collection(userNotificationCollection)
        .document(notificationId);

    return notification.updateData({'read': true}).catchError((error) {
      print('Error updating notification: $error');
    });
  }
}
