import 'package:canteen_frontend/screens/onboarding/bloc/bloc.dart';
import 'package:canteen_frontend/screens/onboarding/onboarding_complete_screen.dart';
import 'package:canteen_frontend/screens/onboarding/welcome_screen.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'onboarding_sign_up_screens.dart';

class OnboardingScreen extends StatelessWidget {
  Widget _buildOnboardingWidget(BuildContext context, OnboardingState state) {
    if (state is WelcomeScreenLoaded) {
      return WelcomeScreen();
    } else if (state is OnboardingSignUpScreensLoaded) {
      return OnboardingSignUpScreens(state.user);
    } else if (state is OnboardingCompleteScreenLoaded) {
      return OnboardingCompleteScreen();
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (BuildContext context, OnboardingState state) {
      return AnimatedSwitcher(
        duration: Duration(milliseconds: animationDuration),
        switchOutCurve: Threshold(0),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(offsetdXForward, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        child: _buildOnboardingWidget(context, state),
      );
    });
  }
}
