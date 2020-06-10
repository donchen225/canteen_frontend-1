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
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: BackButton(
          onPressed: () => Navigator.maybePop(context),
          color: Palette.primaryColor,
        ),
        title: Container(
          height: kToolbarHeight - 10,
          width: kToolbarHeight - 10,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/loading-icon.png'),
            ),
          ),
        ),
      ),
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(userRepository: _userRepository),
        child: LoginForm(userRepository: _userRepository),
      ),
    );
  }
}
