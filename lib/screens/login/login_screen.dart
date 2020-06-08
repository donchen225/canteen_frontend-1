import 'package:canteen_frontend/screens/landing/landing_screen.dart';
import 'package:canteen_frontend/screens/sign_up/sign_up_screen.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';

import 'package:canteen_frontend/screens/login/bloc/bloc.dart';
import 'login_form.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';

  final UserRepository _userRepository;

  LoginScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.scaffoldBackgroundLightColor,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.maybePop(context),
          color: Palette.primaryColor,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(userRepository: _userRepository),
        child: LoginForm(userRepository: _userRepository),
      ),
    );
  }
}
