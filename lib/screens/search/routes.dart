import 'package:canteen_frontend/components/view_user_profile_screen.dart';
import 'package:canteen_frontend/models/arguments.dart';
import 'package:canteen_frontend/screens/search/arguments.dart';
import 'package:canteen_frontend/screens/search/discover_screen.dart';
import 'package:canteen_frontend/screens/search/search_results_screen.dart';
import 'package:canteen_frontend/screens/search/searching_screen.dart';
import 'package:flutter/material.dart';

MaterialPageRoute buildSearchScreenRoutes(RouteSettings settings) {
  return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) {
        switch (settings.name) {
          case DiscoverScreen.routeName:
            return DiscoverScreen();
          case SearchingScreen.routeName:
            final SearchArguments args = settings.arguments;
            return SearchingScreen(
                initialQuery: args.initialQuery,
                searchHistory: args.searchHistory);
          case SearchResultScreen.routeName:
            final SearchResultsArguments args = settings.arguments;
            return SearchResultScreen(query: args.query);

          case ViewUserProfileScreen.routeName:
            final UserArguments args = settings.arguments;
            return ViewUserProfileScreen(user: args.user);
        }
      });
}
