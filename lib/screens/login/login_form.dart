import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/login/create_account_button.dart';
import 'package:canteen_frontend/shared_blocs/authentication/bloc.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bloc.dart';
import 'login_button.dart';

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
  final Color _textColor = Colors.white;
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
      return '';
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
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        // if (state.isSubmitting) {
        //   Scaffold.of(context)
        //     ..hideCurrentSnackBar()
        //     ..showSnackBar(
        //       SnackBar(
        //         content: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Text('Logging In...'),
        //             CupertinoActivityIndicator(),
        //           ],
        //         ),
        //       ),
        //     );
        // }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Form(
            child: ListView(
              padding: EdgeInsets.only(
                  top: SizeConfig.instance.blockSizeVertical * 9,
                  left: SizeConfig.instance.blockSizeHorizontal * 9,
                  right: SizeConfig.instance.blockSizeHorizontal * 9),
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: SizeConfig.instance.blockSizeVertical * 3,
                        bottom: SizeConfig.instance.blockSizeVertical * 3),
                    child: Text(
                      'Canteen',
                      style: TextStyle(
                        color: _textColor,
                        fontSize: 40,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: SizeConfig.instance.blockSizeVertical,
                      bottom: SizeConfig.instance.blockSizeVertical),
                  child: TextFormField(
                    controller: _emailController,
                    style: TextStyle(color: _textColor),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Email',
                      labelStyle: TextStyle(color: _textColor),
                      fillColor: Colors.white.withOpacity(0.1),
                      filled: true,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: SizeConfig.instance.blockSizeVertical,
                      bottom: SizeConfig.instance.blockSizeVertical),
                  child: TextFormField(
                    style: TextStyle(color: _textColor),
                    controller: _passwordController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Password',
                      labelStyle: TextStyle(color: _textColor),
                      fillColor: Colors.white.withOpacity(0.1),
                      filled: true,
                    ),
                    obscureText: true,
                    autocorrect: false,
                  ),
                ),
                // TODO: change this error to a pop up
                Visibility(
                  visible: state.isFailure,
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        getErrorMessage(state.error),
                        style: TextStyle(color: Colors.red),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.instance.blockSizeVertical * 3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      LoginButton(
                        onPressed: isLoginButtonEnabled(state)
                            ? _onFormSubmitted
                            : null,
                      ),
                      CreateAccountButton(userRepository: _userRepository),
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
