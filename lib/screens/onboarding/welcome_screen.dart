import 'package:canteen_frontend/screens/onboarding/bloc/bloc.dart';
import 'package:canteen_frontend/screens/onboarding/bloc/onboarding_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Expanded(
          child: Container(color: Colors.red),
        ),
        Flexible(
          child: SafeArea(
            child: Container(
              child: RaisedButton(
                onPressed: () {
                  BlocProvider.of<OnboardingBloc>(context)
                      .add(LoadOnboardingScreen());
                },
                color: Colors.orange[500],
                child: Text('Continue'),
              ),
            ),
          ),
        )
      ],
    ));
  }
}
