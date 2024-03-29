import 'package:canteen_frontend/screens/onboarding/bloc/bloc.dart';
import 'package:canteen_frontend/screens/onboarding/next_button.dart';
import 'package:canteen_frontend/screens/onboarding/onboarding_profile_picture_screen.dart';
import 'package:canteen_frontend/screens/onboarding/onboarding_screen.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingWebsiteScreen extends StatefulWidget {
  static const routeName = '/website';

  final Widget child;

  OnboardingWebsiteScreen({this.child});

  @override
  _OnboardingWebsiteScreenState createState() =>
      _OnboardingWebsiteScreenState();
}

class _OnboardingWebsiteScreenState extends State<OnboardingWebsiteScreen> {
  TextEditingController _nameController;
  bool _nextEnabled;
  final int _textFieldMaxChars = 40;
  FocusNode _focusNode;

  void initState() {
    super.initState();

    _nextEnabled = false;
    _focusNode = FocusNode();
    _nameController = TextEditingController();
    _nameController.addListener(_enableButton);
  }

  void _enableButton() {
    setState(() {
      _nextEnabled = _nameController.text.length > 1;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titleTextStyle = Theme.of(context).textTheme.headline4;
    final nextFunction = () {
      BlocProvider.of<OnboardingBloc>(context)
          .add(UpdateName(name: _nameController.text));
      Navigator.pushNamed(context, OnboardingProfilePictureScreen.routeName);
    };

    return OnboardingScreen(
      next: NextButton(
          onTap: _nextEnabled
              ? () {
                  if (_nameController.text.length > 1) {
                    nextFunction();
                  }
                }
              : null),
      nodes: [_focusNode],
      onSkip: nextFunction,
      child: Container(
        color: Colors.transparent,
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
                'Add your website',
                style: titleTextStyle.apply(
                  color: Palette.titleColor,
                  fontWeightDelta: 3,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.instance.safeBlockVertical * 2,
                ),
                child: TextField(
                  controller: _nameController,
                  focusNode: _focusNode,
                  textCapitalization: TextCapitalization.sentences,
                  cursorColor: Palette.primaryColor,
                  style: titleTextStyle.apply(
                    color: Palette.textColor,
                    fontWeightDelta: 2,
                  ),
                  decoration: InputDecoration(
                    counterText:
                        (_textFieldMaxChars - _nameController.text.length)
                                ?.toString() ??
                            "",
                    hintText: "Your website URL",
                    contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    isDense: true,
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  maxLength: _textFieldMaxChars,
                  maxLines: 2,
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
