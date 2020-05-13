import 'package:canteen_frontend/screens/onboarding/bloc/bloc.dart';
import 'package:canteen_frontend/screens/onboarding/bloc/onboarding_event.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final buttonFontStyle = Theme.of(context).textTheme.headline5;

    return Scaffold(
        body: Container(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.instance.blockSizeHorizontal * 6),
      color: Palette.backgroundColor,
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
                    style: TextStyle(fontSize: 33, fontWeight: FontWeight.w800),
                  ),
                ),
                Container(
                  child: Text(
                    'The app where you can connect, learn, and earn money.',
                    style: TextStyle(fontSize: 33, fontWeight: FontWeight.w800),
                  ),
                )
              ],
            )),
          ),
          Flexible(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: buttonFontStyle.fontSize * kButtonHeightToFontRatio,
                    width: buttonFontStyle.fontSize *
                        kButtonHeightToFontRatio *
                        kButtonAspectRatio,
                    child: RaisedButton(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                      onPressed: () {
                        BlocProvider.of<OnboardingBloc>(context)
                            .add(LoadOnboarding());
                      },
                      color: Palette.orangeColor,
                      child: Text(
                        'Continue',
                        style: buttonFontStyle.apply(
                          color: Colors.white,
                        ),
                      ),
                    ),
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
