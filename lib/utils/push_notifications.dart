import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:canteen_frontend/models/user_settings/settings_repository.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// PushNotificationsManager - Manages all push notifications
// Types of push notifications:
// * Chat message
// * Request received
// * Matched (Request accepted)
class PushNotificationsManager {
  SettingsRepository _settingsRepository;
  // TODO: figure out when to close this
  StreamSubscription _iosSubscription;
  bool _initialized = false;

  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Future<void> init(SettingsRepository settingsRepository) async {
    if (!_initialized) {
      _settingsRepository = settingsRepository;

      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
        },
      );

      if (Platform.isIOS) {
        _iosSubscription?.cancel();
        _iosSubscription = _firebaseMessaging.onIosSettingsRegistered
            .listen((IosNotificationSettings settings) {
          // Save settings to firestore
          print('ON SETTINGS REGISTERED');
          print(settings);
          saveSettings(settings);
        });

        registerSettings();
      }

      _firebaseMessaging.onTokenRefresh.listen((token) {
        // Save token to firestore
        print('ON TOKEN REFRESH');
        assert(token != null);

        saveToken(token);
      });

      _firebaseMessaging.getToken().then((String token) {
        // Save token to firestore
        print('GET TOKEN');
        assert(token != null);

        saveToken(token);
      });

      _initialized = true;
    }
  }

  void registerSettings() {
    _firebaseMessaging
        .requestNotificationPermissions(const IosNotificationSettings());
  }

  Future<void> saveSettings(IosNotificationSettings settings) async {
    final String settingsJson = jsonEncode(<String, bool>{
      'sound': settings.sound,
      'alert': settings.alert,
      'badge': settings.badge,
      'provisional': settings.provisional,
    });

    CachedSharedPreferences.setString(
        PreferenceConstants.pushNotificationsSystem, settingsJson);
  }

  Future<void> saveToken(String token) async {
    String identifier = "";
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      identifier = build.androidId; //UUID for Android
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
      identifier = data.identifierForVendor; //UUID for iOS
    }

    CachedSharedPreferences.setString(PreferenceConstants.deviceId, identifier);

    return _settingsRepository.saveToken(token, identifier);
  }
}
