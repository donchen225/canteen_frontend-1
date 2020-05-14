import 'package:canteen_frontend/components/main_button.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/login/login_screen.dart';
import 'package:canteen_frontend/screens/sign_up/bloc/bloc.dart';
import 'package:canteen_frontend/shared_blocs/authentication/bloc.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpForm extends StatefulWidget {
  final UserRepository _userRepository;

  SignUpForm({UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  SignUpBloc _registerBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isRegisterButtonEnabled(SignUpState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<SignUpBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<SignUpBloc, SignUpState>(
        builder: (context, state) {
          return Form(
            child: ListView(
              padding: EdgeInsets.only(
                top: SizeConfig.instance.safeBlockVertical * 20,
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
                      'Sign Up',
                      style: Theme.of(context).textTheme.headline4.apply(
                            color: Palette.titleColor,
                            fontWeightDelta: 3,
                          ),
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
                  state.isFailure
                      ? state.error.message
                      : '''
                  
                  ''',
                  style: TextStyle(color: Colors.red),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.instance.safeBlockVertical),
                  child: MainButton(
                    height: SizeConfig.instance.safeBlockHorizontal *
                        (100 - (2 * kLandingHorizontalPaddingBlocks)) /
                        kButtonAspectRatio,
                    color: Palette.orangeColor,
                    text: 'Next',
                    onPressed: isRegisterButtonEnabled(state)
                        ? _onFormSubmitted
                        : null,
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
                        'Already have an account? ',
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return LoginScreen(
                                    userRepository: widget._userRepository);
                              }),
                            );
                          },
                          child: Text(
                            'Sign In',
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
    _registerBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _registerBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _registerBloc.add(
      Submitted(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}
