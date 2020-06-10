import 'dart:async';

import 'package:canteen_frontend/models/notification/notification.dart';
import 'package:canteen_frontend/models/notification/notification_entity.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:tuple/tuple.dart';

class NotificationRepository {
  final notificationCollection = Firestore.instance.collection('notifications');
  final userNotificationCollection = 'notifications';
  final childNotificationCollection = 'child_notifications';

  NotificationRepository();

  Future<Tuple2<List<Notification>, DocumentSnapshot>> getPosts(
      {DocumentSnapshot startAfterDocument}) {
    final userId =
        CachedSharedPreferences.getString(PreferenceConstants.userId);

    Query query = notificationCollection
        .document(userId)
        .collection(userNotificationCollection)
        .orderBy("last_updated", descending: true)
        .limit(25);

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
}
