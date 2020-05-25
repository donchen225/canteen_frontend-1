import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/sign_up/sign_up_form.dart';
import 'package:canteen_frontend/shared_blocs/login_navigation/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:canteen_frontend/screens/sign_up/bloc/bloc.dart';

class SignUpScreen extends StatelessWidget {
  final UserRepository _userRepository;

  SignUpScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => BlocProvider.of<LoginNavigationBloc>(context)
              .add(LoginPreviousState()),
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
