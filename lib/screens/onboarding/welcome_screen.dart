import 'package:canteen_frontend/components/main_button.dart';
import 'package:canteen_frontend/screens/onboarding/onboarding_name_screen.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    final titleTextStyle = Theme.of(context).textTheme.headline3.apply(
          color: Palette.textColor,
          fontWeightDelta: 2,
        );

    return Scaffold(
        backgroundColor: Palette.scaffoldBackgroundLightColor,
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.instance.safeBlockHorizontal *
                  kLandingHorizontalPaddingBlocks),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.instance.safeBlockVertical * 9),
                      child: Text(
                        'Welcome to Canteen.',
                        style: titleTextStyle,
                      ),
                    ),
                    Container(
                      child: Text(
                        'The app where you can connect, learn, and earn money.',
                        style: titleTextStyle,
                      ),
                    )
                  ],
                )),
              ),
              Expanded(
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: MainButton(
                              height: SizeConfig.instance.safeBlockHorizontal *
                                  (100 -
                                      (2 * kLandingHorizontalPaddingBlocks)) /
                                  kButtonAspectRatio,
                              onPressed: () => Navigator.pushNamed(
                                  context, OnboardingNameScreen.routeName),
                              color: Palette.primaryColor,
                              text: 'Continue',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
