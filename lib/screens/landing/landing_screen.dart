import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/login/login_screen.dart';
import 'package:canteen_frontend/screens/sign_up/sign_up_screen.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  final UserRepository _userRepository;

  LandingScreen({UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

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
                        onPressed: () {},
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
