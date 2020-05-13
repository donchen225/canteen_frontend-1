import 'package:canteen_frontend/components/facebook_web_view.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/login/login_screen.dart';
import 'package:canteen_frontend/screens/sign_up/sign_up_screen.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  final UserRepository _userRepository;

  LandingScreen({UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  Route _createRoute(Widget route) {
    return PageRouteBuilder(
      maintainState: true,
      pageBuilder: (context, animation, secondaryAnimation) => route,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Future<void> loginWithFacebook(BuildContext context) async {
    String fbAppId = "545393946358900";
    String redirectUrl = "https://www.facebook.com/connect/login_success.html";

    print('in login function');
    await Navigator.push(
        context,
        _createRoute(
          FacebookWebView(
              selectedUrl:
                  // 'https://www.facebook.com/dialog/oauth?client_id=$fbAppId&redirect_uri=$redirectUrl&response_type=token&scope=email,public_profile,',
                  'https://www.google.com'),
        ));
    // print('RESULT: $result');

    // if (result != null) {
    //   try {
    //     final facebookAuthCred =
    //         FacebookAuthProvider.getCredential(accessToken: result);
    //     // final user = await firebaseAuth
    //     //     .signInWithCredential(facebookAuthCred);
    //   } catch (e) {}
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.instance.safeBlockHorizontal * 10,
      ),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.instance.safeBlockVertical * 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: SizeConfig.instance.safeBlockHorizontal * 10,
                        width: SizeConfig.instance.safeBlockHorizontal * 10,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/loading-icon.png'),
                          ),
                        ),
                      ),
                      Text(
                        'Canteen',
                        style: Theme.of(context).textTheme.headline3.apply(
                              color: Palette.orangeColor,
                            ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.instance.safeBlockVertical,
                  ),
                  child: Text(
                    'The most engaging communication platform for online communities.',
                    style: Theme.of(context).textTheme.headline4.apply(
                          fontWeightDelta: 2,
                          color: Colors.black,
                        ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.instance.safeBlockVertical * 2,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        color: Palette.orangeColor,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.instance.safeBlockVertical * 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(kButtonBorderRadius),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Continue With Facebook',
                              style: Theme.of(context).textTheme.button.apply(
                                    fontSizeFactor: 1.2,
                                    color: Colors.white,
                                    fontWeightDelta: 1,
                                  ),
                            ),
                          ],
                        ),
                        onPressed: () async {
                          print('FB LOGIN PRESSED');
                          await loginWithFacebook(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      elevation: 0,
                      highlightElevation: 0,
                      color: Colors.white,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.grey.withOpacity(0.2),
                      padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.instance.safeBlockVertical * 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 3, color: Palette.orangeColor),
                        borderRadius: BorderRadius.circular(
                          kButtonBorderRadius,
                        ),
                      ),
                      child: Text(
                        'Sign Up With Email',
                        style: Theme.of(context).textTheme.button.apply(
                              fontSizeFactor: 1.2,
                              color: Palette.orangeColor,
                              fontWeightDelta: 1,
                            ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return SignUpScreen(
                                userRepository: _userRepository);
                          }),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.instance.safeBlockVertical * 2,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                        padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.instance.safeBlockVertical,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(kButtonBorderRadius),
                        ),
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.button,
                            children: <TextSpan>[
                              TextSpan(text: 'Already have an account? '),
                              TextSpan(
                                text: 'Log In',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return LoginScreen(
                                  userRepository: _userRepository);
                            }),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
        ],
      ),
    ));
  }
}
