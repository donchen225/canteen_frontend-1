import 'package:canteen_frontend/components/view_user_profile_screen.dart';
import 'package:canteen_frontend/models/arguments.dart';
import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/screens/posts/arguments.dart';
import 'package:canteen_frontend/screens/posts/bloc/post_bloc.dart';
import 'package:canteen_frontend/screens/posts/post_home_screen.dart';
import 'package:canteen_frontend/screens/posts/single_post_body.dart';
import 'package:canteen_frontend/screens/posts/single_post_screen.dart';
import 'package:canteen_frontend/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

MaterialPageRoute buildHomeScreenRoutes(
    BuildContext context, RouteSettings settings,
    {Key homeKey}) {
  return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext builderContext) {
        switch (settings.name) {
          case PostHomeScreen.routeName:
            return PostHomeScreen();
          case ViewUserProfileScreen.routeName:
            final UserArguments args = settings.arguments;
            return ViewUserProfileScreen(
              user: args?.user ?? null,
              editable: args?.editable ?? false,
            );
          case SinglePostScreen.routeName:
            final SinglePostArguments args = settings.arguments;
            return SinglePostScreen(
              body: SinglePostBody(
                post: args.post as DetailedPost,
                groupId: args.groupId,
                postBloc: BlocProvider.of<HomePostBloc>(context),
              ),
            );
          case SettingsScreen.routeName:
            return SettingsScreen();
        }
      });
}
