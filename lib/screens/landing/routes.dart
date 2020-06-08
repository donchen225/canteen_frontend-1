import 'package:canteen_frontend/screens/landing/landing_screen.dart';
import 'package:canteen_frontend/screens/login/login_screen.dart';
import 'package:canteen_frontend/screens/sign_up/sign_up_screen.dart';
import 'package:canteen_frontend/shared_blocs/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

MaterialPageRoute buildLandingScreenRoutes(RouteSettings settings) {
  return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) {
        switch (settings.name) {
          case LandingScreen.routeName:
            return LandingScreen();
          case SignUpScreen.routeName:
            return SignUpScreen(
              userRepository: BlocProvider.of<UserBloc>(context).userRepository,
            );
          case LoginScreen.routeName:
            return LoginScreen(
              userRepository: BlocProvider.of<UserBloc>(context).userRepository,
            );
        }
      });
}
