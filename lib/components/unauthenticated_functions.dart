import 'package:canteen_frontend/screens/sign_up/bloc/sign_up_bloc.dart';
import 'package:canteen_frontend/screens/sign_up/sign_up_screen.dart';
import 'package:canteen_frontend/shared_blocs/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnauthenticatedFunctions {
  static void showSignUp(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider<SignUpBloc>(
        create: (context) => SignUpBloc(
            userRepository: BlocProvider.of<UserBloc>(context).userRepository),
        child: SignUpScreen(),
      ),
    );
  }
}
