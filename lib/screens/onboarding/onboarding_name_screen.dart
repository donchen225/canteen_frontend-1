import 'package:canteen_frontend/screens/onboarding/bloc/bloc.dart';
import 'package:canteen_frontend/screens/onboarding/next_button.dart';
import 'package:canteen_frontend/screens/onboarding/onboarding_screen.dart';
import 'package:canteen_frontend/screens/onboarding/onboarding_website_screen.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingNameScreen extends StatefulWidget {
  static const routeName = '/name';

  final Widget child;

  OnboardingNameScreen({this.child});

  @override
  _OnboardingNameScreenState createState() => _OnboardingNameScreenState();
}

class _OnboardingNameScreenState extends State<OnboardingNameScreen> {
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

  void _nextFunction(BuildContext context) {
    BlocProvider.of<OnboardingBloc>(context)
        .add(UpdateName(name: _nameController.text));
    Navigator.pushNamed(context, OnboardingWebsiteScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final titleTextStyle = Theme.of(context).textTheme.headline4;

    return OnboardingScreen(
      next: NextButton(
          onTap: _nextEnabled
              ? () {
                  if (_nameController.text.length > 1) {
                    _nextFunction(context);
                  }
                }
              : null),
      nodes: [_focusNode],
      onSkip: () => _nextFunction(context),
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
                'Add your name',
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
                    hintText: "Your name",
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
