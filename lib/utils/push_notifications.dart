import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;
  StreamSubscription _iosSubscription;

  Future<void> init() async {
    if (!_initialized) {
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
        });

        registerSettings();
      }

      _firebaseMessaging.onTokenRefresh.listen((token) {
        // Save token to firestore
        print('ON TOKEN REFRESH');
        print(token);
      });

      _firebaseMessaging.getToken().then((String token) {
        // Save token to firestore
        print('GET TOKEN');
        assert(token != null);

        print(token);
      });

      _initialized = true;
    }
  }

  void registerSettings() {
    _firebaseMessaging
        .requestNotificationPermissions(const IosNotificationSettings());
  }
}
