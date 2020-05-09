import 'dart:io';

import 'package:canteen_frontend/models/user_settings/user_settings.dart';
import 'package:canteen_frontend/models/user_settings/user_settings_entity.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsRepository {
  final userCollection = Firestore.instance.collection('users');

  SettingsRepository();

  UserSettings getCurrentSettings() {
    final pushNotifications =
        CachedSharedPreferences.getBool(PreferenceConstants.pushNotifications);
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

  Future<void> saveToken(String token) {
    final userId =
        CachedSharedPreferences.getString(PreferenceConstants.userId);

    print('TOKEN: $token');
    if (token == null || token.isEmpty) {
      return null;
    }

    final ref =
        userCollection.document(userId).collection('tokens').document(token);

    return Firestore.instance.runTransaction((Transaction tx) async {
      final doc = await tx.get(ref);

      if (!(doc.exists)) {
        await tx.set(ref, {
          "token": token,
          "created_on": FieldValue.serverTimestamp(),
          "platform": Platform.operatingSystem,
        });
      }
    });
  }
}
