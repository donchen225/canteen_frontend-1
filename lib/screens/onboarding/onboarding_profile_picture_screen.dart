import 'package:canteen_frontend/components/profile_upload_sheet.dart';
import 'package:canteen_frontend/screens/onboarding/bloc/bloc.dart';
import 'package:canteen_frontend/screens/onboarding/next_button.dart';
import 'package:canteen_frontend/screens/onboarding/onboarding_about_screen.dart';
import 'package:canteen_frontend/screens/onboarding/onboarding_screen.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingProfilePictureScreen extends StatefulWidget {
  static const routeName = '/picture';

  final Widget child;

  OnboardingProfilePictureScreen({this.child});

  @override
  _OnboardingProfilePictureScreenState createState() =>
      _OnboardingProfilePictureScreenState();
}

class _OnboardingProfilePictureScreenState
    extends State<OnboardingProfilePictureScreen> {
  String _photoUrl;

  void initState() {
    super.initState();

    _photoUrl = '';
  }

  void showPopUpSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext localContext) =>
          ProfileUploadSheet(onUpload: (imageFile) {
        BlocProvider.of<OnboardingBloc>(context)
            .add(UpdatePhoto(file: imageFile));
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleTextStyle = Theme.of(context).textTheme.headline4;
    final bodyTextStyle = Theme.of(context).textTheme.bodyText1;
    final nextFunction = () {
      Navigator.pushNamed(context, OnboardingAboutScreen.routeName);
    };

    return BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (BuildContext context, OnboardingState state) {
      if (state is OnboardingInProgress) {
        _photoUrl = state.photoUrl;
      }

      return OnboardingScreen(
        next: NextButton(onTap: _photoUrl.isNotEmpty ? nextFunction : null),
        onSkip: nextFunction,
        child: Container(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(
              top: SizeConfig.instance.safeBlockVertical * 3,
              bottom: SizeConfig.instance.safeBlockVertical * 3,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pick a profile picture',
                  style: titleTextStyle.apply(
                    color: Palette.titleColor,
                    fontWeightDelta: 3,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.instance.safeBlockVertical * 1.5,
                  ),
                  child: Text(
                    'Have a favorite selfie? Upload it now.',
                    style: bodyTextStyle,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.instance.safeBlockVertical * 4,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () => showPopUpSheet(context),
                      child: ProfilePicture(
                        photoUrl: _photoUrl,
                        shape: BoxShape.circle,
                        editable: true,
                        size: SizeConfig.instance.safeBlockHorizontal * 40,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
