import 'package:canteen_frontend/screens/posts/arguments.dart';
import 'package:canteen_frontend/screens/posts/post_home_screen.dart';
import 'package:canteen_frontend/screens/posts/single_post_screen.dart';
import 'package:canteen_frontend/screens/search/view_user_profile_screen.dart';
import 'package:flutter/material.dart';

MaterialPageRoute buildPostScreenRoutes(RouteSettings settings) {
  return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) {
        switch (settings.name) {
          case PostHomeScreen.routeName:
            return PostHomeScreen();
          case ViewUserProfileScreen.routeName:
            final UserPostArguments args = settings.arguments;
            return ViewUserProfileScreen(user: args.user);
          case SinglePostScreen.routeName:
            final SinglePostArguments args = settings.arguments;
            return SinglePostScreen(
              post: args.post,
            );
        }
      });
}
