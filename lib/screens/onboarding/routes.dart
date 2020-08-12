import 'package:canteen_frontend/screens/onboarding/onboarding_about_screen.dart';
import 'package:canteen_frontend/screens/onboarding/onboarding_group_screen.dart';
import 'package:canteen_frontend/screens/onboarding/onboarding_name_screen.dart';
import 'package:canteen_frontend/screens/onboarding/onboarding_profile_picture_screen.dart';
import 'package:canteen_frontend/screens/onboarding/onboarding_skill_screen.dart';
import 'package:canteen_frontend/screens/onboarding/onboarding_website_screen.dart';
import 'package:canteen_frontend/screens/onboarding/welcome_screen.dart';
import 'package:flutter/material.dart';

MaterialPageRoute buildOnboardingScreenRoutes(RouteSettings settings) {
  return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) {
        switch (settings.name) {
          case WelcomeScreen.routeName:
            return WelcomeScreen();
        }
        switch (settings.name) {
          case OnboardingNameScreen.routeName:
            return OnboardingNameScreen();
        }
        switch (settings.name) {
          case OnboardingWebsiteScreen.routeName:
            return OnboardingWebsiteScreen();
        }
        switch (settings.name) {
          case OnboardingProfilePictureScreen.routeName:
            return OnboardingProfilePictureScreen();
        }
        switch (settings.name) {
          case OnboardingAboutScreen.routeName:
            return OnboardingAboutScreen();
        }
        switch (settings.name) {
          case OnboardingSkillScreen.routeName:
            return OnboardingSkillScreen();
        }
        switch (settings.name) {
          case OnboardingGroupScreen.routeName:
            return OnboardingGroupScreen();
        }
      });
}
