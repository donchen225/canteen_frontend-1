import 'dart:io';

import 'package:canteen_frontend/models/user_settings/user_settings.dart';
import 'package:canteen_frontend/models/user_settings/user_settings_entity.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsRepository {
  final userCollection = Firestore.instance.collection('users');

  SettingsRepository();

  UserSettings getCurrentSettings() {
    final pushNotifications = CachedSharedPreferences.getBool(
        PreferenceConstants.pushNotificationsApp);
    final timeZone =
        CachedSharedPreferences.getInt(PreferenceConstants.timeZone);
    final timeZoneName =
        CachedSharedPreferences.getString(PreferenceConstants.timeZoneName);
    final settingsInitialized = CachedSharedPreferences.getBool(
        PreferenceConstants.settingsInitialized);

    return settingsInitialized
        ? UserSettings(
            pushNotifications: pushNotifications,
            timeZone: timeZone,
            timeZoneName: timeZoneName,
            settingsInitialized: settingsInitialized)
        : null;
  }

  Future<void> createSettings(UserSettings settings) async {
    final userId =
        CachedSharedPreferences.getString(PreferenceConstants.userId);
    return Firestore.instance.runTransaction((Transaction tx) async {
      await tx.set(
          userCollection
              .document(userId)
              .collection('settings')
              .document('$userId-settings'),
          settings.toEntity().toDocument());
    });
  }

  Future<UserSettings> getSettings() async {
    final userId =
        CachedSharedPreferences.getString(PreferenceConstants.userId);
    return userCollection
        .document(userId)
        .collection('settings')
        .document('$userId-settings')
        .get()
        .then((snapshot) {
      if (!snapshot.exists) {
        return null;
      }
      return UserSettings.fromEntity(UserSettingsEntity.fromSnapshot(snapshot));
    });
  }

  Future<void> toggleDevicePushNotification(String deviceId, bool value) async {
    final userId =
        CachedSharedPreferences.getString(PreferenceConstants.userId);

    final ref =
        userCollection.document(userId).collection('tokens').document(deviceId);

    return ref.get().then((documentSnapshot) {
      if (documentSnapshot.exists) {
        ref.setData({
          "active": value,
        }, merge: true);
      }
    });
  }

  Future<void> toggleSettingPushNotification(bool value) {
    final userId =
        CachedSharedPreferences.getString(PreferenceConstants.userId);

    CachedSharedPreferences.setBool(
        PreferenceConstants.pushNotificationsApp, value);

    return userCollection
        .document(userId)
        .collection('settings')
        .document('$userId-settings')
        .setData({"push_notifications": value}, merge: true);
  }

  Future<void> saveToken(String token, String deviceId) {
    final userId =
        CachedSharedPreferences.getString(PreferenceConstants.userId);
    final pushNotificationApp = CachedSharedPreferences.getBool(
        PreferenceConstants.pushNotificationsApp);

    if (token == null || token.isEmpty) {
      return null;
    }

    final ref =
        userCollection.document(userId).collection('tokens').document(deviceId);

    return ref.get().then((documentSnapshot) {
      var data = {
        "token": token,
        "last_updated": FieldValue.serverTimestamp(),
        "platform": Platform.operatingSystem,
        "active": pushNotificationApp,
      };

      if (!documentSnapshot.exists) {
        data["created_on"] = FieldValue.serverTimestamp();
      }

      return ref.setData(data, merge: true);
    });
  }
}
