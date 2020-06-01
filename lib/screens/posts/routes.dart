import 'package:canteen_frontend/components/view_user_profile_screen.dart';
import 'package:canteen_frontend/models/arguments.dart';
import 'package:canteen_frontend/screens/posts/arguments.dart';
import 'package:canteen_frontend/screens/posts/post_home_screen.dart';
import 'package:canteen_frontend/screens/posts/single_post_screen.dart';
import 'package:canteen_frontend/screens/settings/settings_screen.dart';
import 'package:canteen_frontend/shared_blocs/group/group_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

MaterialPageRoute buildPostScreenRoutes(RouteSettings settings, {Key homeKey}) {
  return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) {
        switch (settings.name) {
          case PostHomeScreen.routeName:
            return PostHomeScreen();
          case ViewUserProfileScreen.routeName:
            final UserArguments args = settings.arguments;
            return ViewUserProfileScreen(
              user: args.user,
              editable: args.editable ?? false,
            );
          case SinglePostScreen.routeName:
            final SinglePostArguments args = settings.arguments;
            return SinglePostScreen(
              post: args.post,
            );
          case SettingsScreen.routeName:
            return SettingsScreen();
        }
      });
}
