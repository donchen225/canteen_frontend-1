import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:canteen_frontend/models/user_settings/settings_repository.dart';
import 'package:canteen_frontend/screens/match/match_detail_bloc/bloc.dart';
import 'package:canteen_frontend/screens/match/match_screen.dart';
import 'package:canteen_frontend/screens/notifications/notification_single_post_screen.dart';
import 'package:canteen_frontend/screens/notifications/notification_view_bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/comment_bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/comment_list_bloc/bloc.dart';
import 'package:canteen_frontend/services/home_navigation_bar_service.dart';
import 'package:canteen_frontend/services/navigation_service.dart';
import 'package:canteen_frontend/services/service_locator.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    _settingsRepository = settingsRepository;

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("ONMESSAGE: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("ONLAUNCH: $message");

        onResumeMessage(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("ONRESUME: $message");

        onResumeMessage(message);
      },
    );

    if (Platform.isIOS) {
      getSettings();
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
  }

  void onResumeMessage(Map<String, dynamic> message) {
    final screen = message['screen'];

    if (screen != null) {
      if (screen == 'post') {
        final targetId = message['target_id'];
        final parentId = message['parent_id'];
        final notificationId = message['notification_id'];

        if (targetId != null && parentId != null && notificationId != null) {
          final routeName = '/$screen/$targetId';

          final notificationNavigatorKey =
              getIt<NavigationService>().notificationNavigatorKey;
          final BottomNavigationBar navigationBar =
              getIt<HomeNavigationBarService>()
                  .homeNavigationBarKey
                  .currentWidget;

          final context = notificationNavigatorKey.currentContext;
          BlocProvider.of<NotificationViewBloc>(context).add(
              LoadNotificationPost(
                  postId: targetId,
                  groupId: parentId,
                  notificationId: notificationId,
                  read: false));

          BlocProvider.of<CommentListBloc>(context)
              .add(LoadCommentList(groupId: parentId, postId: targetId));

          navigationBar.onTap(3);

          notificationNavigatorKey.currentState
              .popUntil((Route<dynamic> route) => route is PageRoute);
          notificationNavigatorKey.currentState.push(MaterialPageRoute<void>(
            settings: RouteSettings(name: routeName),
            builder: (BuildContext context) => NotificationSinglePostScreen(),
          ));
        }
      } else if (screen == 'message') {
        final matchId = message['match_id'];

        if (matchId != null) {
          final messageNavigatorKey =
              getIt<NavigationService>().messageNavigatorKey;
          final BottomNavigationBar navigationBar =
              getIt<HomeNavigationBarService>()
                  .homeNavigationBarKey
                  .currentWidget;

          final context = messageNavigatorKey.currentContext;

          BlocProvider.of<MatchDetailBloc>(context)
              .add(LoadMatchFromId(matchId: matchId));

          navigationBar.onTap(2);

          messageNavigatorKey.currentState
              .popUntil((Route<dynamic> route) => route is PageRoute);
          messageNavigatorKey.currentState.pushNamed(MatchScreen.routeName);
        }
      }
    }
  }

  void getSettings() {
    _iosSubscription?.cancel();
    _iosSubscription = _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      // Save settings to firestore
      print('ON SETTINGS REGISTERED');
      print(settings);
      saveSettings(settings);
    });
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
