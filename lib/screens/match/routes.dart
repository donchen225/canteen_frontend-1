import 'package:canteen_frontend/components/view_user_profile_screen.dart';
import 'package:canteen_frontend/models/arguments.dart';
import 'package:canteen_frontend/screens/match/arguments.dart';
import 'package:canteen_frontend/screens/match/match_detail_screen.dart';
import 'package:canteen_frontend/screens/match/message_screen.dart';
import 'package:flutter/material.dart';

MaterialPageRoute buildMessageScreenRoutes(RouteSettings settings) {
  return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) {
        switch (settings.name) {
          case MessageScreen.routeName:
            return MessageScreen();
          case MatchDetailScreen.routeName:
            final MatchArguments args = settings.arguments;
            return MatchDetailScreen(match: args.match);
          case ViewUserProfileScreen.routeName:
            final UserArguments args = settings.arguments;
            return ViewUserProfileScreen(user: args.user);
        }
      });
}
