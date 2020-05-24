import 'package:canteen_frontend/screens/landing/landing_screen.dart';
import 'package:canteen_frontend/screens/sign_up/sign_up_screen.dart';
import 'package:canteen_frontend/shared_blocs/login_navigation/bloc.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';

import 'package:canteen_frontend/screens/login/bloc/bloc.dart';
import 'login_form.dart';

class LoginScreen extends StatelessWidget {
  final UserRepository _userRepository;

  LoginScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  Widget _buildLoginScreen(BuildContext context, LoginNavigationState state) {
    if (state is LandingScreenState) {
      return LandingScreen();
    }

    if (state is LoginScreenState) {
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
        body: BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(userRepository: _userRepository),
          child: LoginForm(userRepository: _userRepository),
        ),
      );
    }

    if (state is SignUpScreenState) {
      return SignUpScreen(
        userRepository: _userRepository,
      );
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginNavigationBloc, LoginNavigationState>(
      builder: (BuildContext context, LoginNavigationState state) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: animationDuration),
          switchOutCurve: Threshold(0),
          child: _buildLoginScreen(context, state),
          transitionBuilder: (Widget child, Animation<double> animation) {
            print('STATE: $state');
            if (state is LoginScreenState || state is SignUpScreenState) {
              if (!(state.previous)) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(offsetdXForward, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              }
            }

            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(offsetdXReverse, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
      },
    );
  }
}
