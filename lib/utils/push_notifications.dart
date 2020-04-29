import 'dart:async';
import 'dart:io';

import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// PushNotificationsManager - Manages all push notifications
// Types of push notifications:
// * Chat message
// * Request received
// * Matched (Request accepted)
class PushNotificationsManager {
  UserRepository _userRepository;
  StreamSubscription _iosSubscription;
  bool _initialized = false;

  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Future<void> init(UserRepository userRepository) async {
    if (!_initialized) {
      _userRepository = userRepository;

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

  Future<void> saveSettings() {}

  Future<void> saveToken(String token) {
    return _userRepository.saveToken(token);
  }
}
