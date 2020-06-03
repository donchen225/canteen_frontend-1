import 'package:canteen_frontend/shared_blocs/login_navigation/login_navigation_bloc.dart';
import 'package:canteen_frontend/shared_blocs/login_navigation/login_navigation_event.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LandingScreen extends StatelessWidget {
  LandingScreen();

  @override
  Widget build(BuildContext context) {
    final buttonFontStyle = Theme.of(context).textTheme.button;
    final buttonHeight = SizeConfig.instance.safeBlockHorizontal *
        (100 - (2 * kLandingHorizontalPaddingBlocks)) /
        kButtonAspectRatio;

    return Scaffold(
      backgroundColor: Palette.scaffoldBackgroundLightColor,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.instance.safeBlockHorizontal *
              kLandingHorizontalPaddingBlocks,
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
                          height: SizeConfig.instance.safeBlockHorizontal * 15,
                          width: SizeConfig.instance.safeBlockHorizontal * 15,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/loading-icon.png'),
                            ),
                          ),
                        ),
                        Text(
                          'Canteen',
                          style: Theme.of(context).textTheme.headline3.apply(
                              color: Palette.textColor, fontWeightDelta: 1),
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
                            color: Palette.textColor,
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
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: buttonHeight,
                        child: RaisedButton(
                          elevation: 0,
                          highlightElevation: 0,
                          color: Palette.primaryColor,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.grey.withOpacity(0.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              100, // TODO: make this a constant
                            ),
                          ),
                          child: Text(
                            'Sign Up With Email',
                            style: buttonFontStyle.apply(
                                fontSizeFactor: buttonHeight /
                                    kButtonHeightToFontRatio /
                                    buttonFontStyle.fontSize,
                                fontWeightDelta: 1,
                                color: Palette.buttonDarkTextColor),
                          ),
                          onPressed: () =>
                              BlocProvider.of<LoginNavigationBloc>(context)
                                  .add(ViewSignupScreen()),
                        ),
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
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Palette.textClickableColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onPressed: () =>
                              BlocProvider.of<LoginNavigationBloc>(context)
                                  .add(ViewLoginScreen()),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
