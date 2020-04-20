import 'package:canteen_frontend/screens/onboarding/bloc/bloc.dart';
import 'package:canteen_frontend/screens/onboarding/bloc/onboarding_event.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.instance.blockSizeHorizontal * 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.instance.safeBlockVertical * 9),
                    child: Text(
                      'Welcome to Canteen.',
                      style:
                          TextStyle(fontSize: 33, fontWeight: FontWeight.w800),
                    ),
                  ),
                  Container(
                    child: Text(
                      'The app where you can connect, learn, and earn money.',
                      style:
                          TextStyle(fontSize: 33, fontWeight: FontWeight.w800),
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
                  height: SizeConfig.instance.safeBlockVertical * 9,
                  width: SizeConfig.instance.safeBlockHorizontal * 42,
                  child: RaisedButton(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    onPressed: () {
                      BlocProvider.of<OnboardingBloc>(context)
                          .add(LoadOnboardingScreen());
                    },
                    color: Colors.orange[500],
                    child: Text(
                      'Continue',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ));
  }
}
