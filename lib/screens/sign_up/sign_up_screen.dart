import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/sign_up/sign_up_form.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:canteen_frontend/screens/sign_up/bloc/bloc.dart';

class SignUpScreen extends StatelessWidget {
  static const routeName = '/signup';

  final UserRepository _userRepository;

  SignUpScreen({Key key, @required UserRepository userRepository})
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
      body: BlocProvider<SignUpBloc>(
        create: (context) => SignUpBloc(userRepository: _userRepository),
        child: SignUpForm(),
      ),
    );
  }
}
