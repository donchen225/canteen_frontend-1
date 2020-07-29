import 'package:canteen_frontend/components/view_user_profile_screen.dart';
import 'package:canteen_frontend/models/arguments.dart';
import 'package:canteen_frontend/screens/posts/group_single_post_screen.dart';
import 'package:canteen_frontend/screens/posts/post_home_screen.dart';
import 'package:canteen_frontend/screens/search/arguments.dart';
import 'package:canteen_frontend/screens/search/search_results_screen.dart';
import 'package:canteen_frontend/screens/search/searching_screen.dart';
import 'package:canteen_frontend/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';

MaterialPageRoute buildHomeScreenRoutes(
    BuildContext context, RouteSettings settings,
    {Key homeKey}) {
  return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext builderContext) {
        switch (settings.name) {
          case PostHomeScreen.routeName:
            return PostHomeScreen();
          case SearchingScreen.routeName:
            final SearchArguments args = settings.arguments;
            return SearchingScreen(initialQuery: args?.initialQuery ?? '');
          case SearchResultScreen.routeName:
            final SearchResultsArguments args = settings.arguments;
            return SearchResultScreen(query: args.query);
          case ViewUserProfileScreen.routeName:
            final UserArguments args = settings.arguments;
            return ViewUserProfileScreen(
              user: args?.user ?? null,
              editable: args?.editable ?? false,
            );
          case GroupSinglePostScreen.routeName:
            return GroupSinglePostScreen();
          case SettingsScreen.routeName:
            return SettingsScreen();
        }
      });
}
