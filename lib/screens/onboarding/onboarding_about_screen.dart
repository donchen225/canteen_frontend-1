import 'package:canteen_frontend/screens/onboarding/bloc/bloc.dart';
import 'package:canteen_frontend/screens/onboarding/next_button.dart';
import 'package:canteen_frontend/screens/onboarding/onboarding_screen.dart';
import 'package:canteen_frontend/screens/onboarding/onboarding_skill_screen.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingAboutScreen extends StatefulWidget {
  static const routeName = '/about';

  final Widget child;

  OnboardingAboutScreen({this.child});

  @override
  _OnboardingAboutScreenState createState() => _OnboardingAboutScreenState();
}

class _OnboardingAboutScreenState extends State<OnboardingAboutScreen> {
  TextEditingController _aboutController;
  bool _nextEnabled;
  final int _textFieldMaxChars = 300;
  FocusNode _focusNode;

  void initState() {
    super.initState();

    _nextEnabled = false;
    _focusNode = FocusNode();
    _aboutController = TextEditingController();
    _aboutController.addListener(_enableButton);
  }

  @override
  void dispose() {
    _aboutController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _enableButton() {
    setState(() {
      _nextEnabled = _aboutController.text.length > 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final titleTextStyle = Theme.of(context).textTheme.headline4;
    final bodyTextStyle = Theme.of(context).textTheme.bodyText1;
    final nextFunction = () {
      BlocProvider.of<OnboardingBloc>(context)
          .add(UpdateAbout(about: _aboutController.text));
      Navigator.pushNamed(context, OnboardingSkillScreen.routeName);
    };

    return OnboardingScreen(
      next: NextButton(
          onTap: _nextEnabled
              ? () {
                  if (_aboutController.text.length > 1) {
                    nextFunction();
                  }
                }
              : null),
      nodes: [_focusNode],
      onSkip: nextFunction,
      child: Container(
        width: double.infinity,
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(
            top: SizeConfig.instance.safeBlockVertical * 3,
            bottom: SizeConfig.instance.safeBlockVertical * 3,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Describe yourself',
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
                  "What makes you special? Don't think too hard, just have fun with it.",
                  style: bodyTextStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.instance.safeBlockVertical * 2,
                ),
                child: TextField(
                  controller: _aboutController,
                  focusNode: _focusNode,
                  textCapitalization: TextCapitalization.sentences,
                  cursorColor: Palette.primaryColor,
                  style: bodyTextStyle.apply(
                    color: Palette.textColor,
                    fontWeightDelta: 2,
                  ),
                  decoration: InputDecoration(
                    counterText:
                        (_textFieldMaxChars - _aboutController.text.length)
                                ?.toString() ??
                            "",
                    hintText: "Your bio",
                    contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    isDense: true,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  maxLength: _textFieldMaxChars,
                  maxLines: null,
                  minLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
