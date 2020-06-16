import 'package:canteen_frontend/components/view_user_profile_screen.dart';
import 'package:canteen_frontend/models/arguments.dart';
import 'package:canteen_frontend/screens/notifications/notification_screen.dart';
import 'package:canteen_frontend/screens/notifications/notification_single_post_screen.dart';
import 'package:canteen_frontend/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';

MaterialPageRoute buildNotificationScreenRoutes(RouteSettings settings) {
  return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) {
        switch (settings.name) {
          case NotificationScreen.routeName:
            return NotificationScreen();
          case ViewUserProfileScreen.routeName:
            final UserArguments args = settings.arguments;
            return ViewUserProfileScreen(
              user: args.user,
              editable: args.editable ?? false,
            );
          case SettingsScreen.routeName:
            return SettingsScreen();
          case NotificationSinglePostScreen.routeName:
            return NotificationSinglePostScreen();
        }
      });
}
