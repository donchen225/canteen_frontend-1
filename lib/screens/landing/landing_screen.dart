import 'package:canteen_frontend/screens/login/login_screen.dart';
import 'package:canteen_frontend/screens/sign_up/sign_up_screen.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingScreen extends StatelessWidget {
  static const routeName = '/';

  LandingScreen();

  @override
  Widget build(BuildContext context) {
    final buttonFontStyle = Theme.of(context).textTheme.button;
    final buttonHeight = SizeConfig.instance.safeBlockHorizontal *
        (100 - (2 * kLandingHorizontalPaddingBlocks)) /
        kButtonAspectRatio;
    final bodyTextStyle = Theme.of(context).textTheme.bodyText1;

    return Scaffold(
      backgroundColor: Palette.scaffoldBackgroundLightColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
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
                      vertical: SizeConfig.instance.safeBlockVertical * 6,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Canteen',
                          style: GoogleFonts.arvo(
                            textStyle:
                                Theme.of(context).textTheme.headline2.apply(
                                      color: Palette.textColor,
                                      fontWeightDelta: 1,
                                    ),
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
                      'Find what you need & offer your services in our communities.',
                      style: Theme.of(context).textTheme.headline3.apply(
                            fontWeightDelta: 2,
                            color: Palette.textColor,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                flex: 1,
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
                              onPressed: () => Navigator.pushNamed(
                                  context, SignUpScreen.routeName),
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
                                    TextSpan(
                                        text: 'Already have an account? ',
                                        style: bodyTextStyle.apply(
                                            color: Palette
                                                .textSecondaryBaseColor)),
                                    TextSpan(
                                        text: 'Log In',
                                        style: bodyTextStyle.apply(
                                            color: Palette.textClickableColor)),
                                  ],
                                ),
                              ),
                              onPressed: () => Navigator.pushNamed(
                                  context, LoginScreen.routeName),
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
