import 'package:canteen_frontend/components/view_user_profile_screen.dart';
import 'package:canteen_frontend/models/arguments.dart';
import 'package:canteen_frontend/screens/posts/group_single_post_screen.dart';
import 'package:canteen_frontend/screens/search/arguments.dart';
import 'package:canteen_frontend/screens/search/discover_screen.dart';
import 'package:canteen_frontend/screens/search/search_results_screen.dart';
import 'package:canteen_frontend/screens/search/searching_screen.dart';
import 'package:canteen_frontend/screens/search/view_group_screen.dart';
import 'package:canteen_frontend/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';

MaterialPageRoute buildSearchScreenRoutes(
    BuildContext context, RouteSettings settings) {
  return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext builderContext) {
        switch (settings.name) {
          case DiscoverScreen.routeName:
            return DiscoverScreen();
          case SearchingScreen.routeName:
            final SearchArguments args = settings.arguments;
            return SearchingScreen(
              initialQuery: args?.initialQuery ?? '',
              isInitialSearch: args?.isInitialSearch ?? true,
            );
          case SearchResultScreen.routeName:
            final SearchResultsArguments args = settings.arguments;
            return SearchResultScreen(query: args.query, results: args.results);
          case ViewUserProfileScreen.routeName:
            final UserArguments args = settings.arguments;
            return ViewUserProfileScreen(
              user: args?.user ?? null,
            );
          case ViewGroupScreen.routeName:
            final GroupArguments args = settings.arguments;
            return ViewGroupScreen(
              group: args.group,
            );
          case GroupSinglePostScreen.routeName:
            return GroupSinglePostScreen();
          case SettingsScreen.routeName:
            return SettingsScreen();
        }
      });
}
