import 'package:canteen_frontend/components/main_button.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/sign_up/sign_up_screen.dart';
import 'package:canteen_frontend/shared_blocs/authentication/bloc.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bloc.dart';

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;

  LoginForm({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  String getErrorMessage(PlatformException error) {
    if (error == null) {
      return '''

      ''';
    }

    if (error.code == 'ERROR_WRONG_PASSWORD') {
      return 'The password is incorrect.';
    } else if (error.code == 'ERROR_USER_NOT_FOUND') {
      return 'The username does not exist.';
    } else {
      return error.message;
    }
  }

  @override
  Widget build(BuildContext context) {
    final headerTextStyle = Theme.of(context).textTheme.headline4.apply(
          color: Palette.titleColor,
          fontWeightDelta: 3,
        );

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Form(
            child: ListView(
              padding: EdgeInsets.only(
                // top: SizeConfig.instance.safeBlockVertical * 20,
                bottom: SizeConfig.instance.safeBlockVertical * 20,
                left: SizeConfig.instance.safeBlockHorizontal *
                    kLandingHorizontalPaddingBlocks,
                right: SizeConfig.instance.safeBlockHorizontal *
                    kLandingHorizontalPaddingBlocks,
              ),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: SizeConfig.instance.safeBlockVertical * 3,
                      bottom: SizeConfig.instance.safeBlockVertical * 3),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Log in to Canteen',
                      style: headerTextStyle,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: SizeConfig.instance.safeBlockVertical,
                      bottom: SizeConfig.instance.safeBlockVertical),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      hintText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: SizeConfig.instance.safeBlockVertical,
                      bottom: SizeConfig.instance.safeBlockVertical),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      hintText: 'Password',
                    ),
                    obscureText: true,
                    autocorrect: false,
                  ),
                ),
                Text(
                  getErrorMessage(state.error),
                  style: TextStyle(color: Colors.red),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.instance.safeBlockVertical),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      MainButton(
                        height: SizeConfig.instance.safeBlockHorizontal *
                            (100 - (2 * kLandingHorizontalPaddingBlocks)) /
                            kButtonAspectRatio,
                        color: Palette.primaryColor,
                        text: 'Log In',
                        onPressed: isLoginButtonEnabled(state)
                            ? _onFormSubmitted
                            : null,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.instance.safeBlockVertical * 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Don't have an account? ",
                      ),
                      GestureDetector(
                          onTap: () => Navigator.pushNamed(
                              context, SignUpScreen.routeName),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Palette.textClickableColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _loginBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _loginBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _loginBloc.add(
      LoginWithCredentialsPressed(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}
