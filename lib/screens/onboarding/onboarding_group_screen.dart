import 'package:canteen_frontend/components/app_logo.dart';
import 'package:canteen_frontend/screens/home/bloc/bloc.dart';
import 'package:canteen_frontend/screens/onboarding/access_code_dialog.dart';
import 'package:canteen_frontend/screens/onboarding/bloc/bloc.dart';
import 'package:canteen_frontend/screens/onboarding/next_button.dart';
import 'package:canteen_frontend/screens/onboarding/onboarding_screen.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingGroupScreen extends StatefulWidget {
  static const routeName = '/group';

  final Widget child;

  OnboardingGroupScreen({this.child});

  @override
  _OnboardingGroupScreenState createState() => _OnboardingGroupScreenState();
}

class _OnboardingGroupScreenState extends State<OnboardingGroupScreen> {
  TextEditingController _aboutController;
  bool _nextEnabled;
  final int _textFieldMaxChars = 200;
  FocusNode _focusNode;

  void initState() {
    super.initState();

    _nextEnabled = false;
    _focusNode = FocusNode();
    _aboutController = TextEditingController();
    _aboutController.addListener(_enableButton);

    BlocProvider.of<OnboardingBloc>(context).add(LoadGroups());
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
    final subtitleTextStyle = Theme.of(context).textTheme.headline5;
    final bodyTextStyle = Theme.of(context).textTheme.bodyText1;
    final buttonTextStyle = Theme.of(context).textTheme.button;
    final nextFunction = () {
      BlocProvider.of<OnboardingBloc>(context).add(CompleteOnboarding());
      BlocProvider.of<HomeBloc>(context).add(InitializeHome());
    };

    return OnboardingScreen(
      horizontalPadding: false,
      next: NextButton(onTap: nextFunction),
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
              Padding(
                padding: EdgeInsets.only(
                  left: SizeConfig.instance.safeBlockHorizontal *
                      kOnboardingHorizontalPaddingBlocks,
                  right: SizeConfig.instance.safeBlockHorizontal *
                      kOnboardingHorizontalPaddingBlocks,
                ),
                child: Text(
                  'Join a group',
                  style: titleTextStyle.apply(
                    color: Palette.titleColor,
                    fontWeightDelta: 3,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: SizeConfig.instance.safeBlockHorizontal *
                      kOnboardingHorizontalPaddingBlocks,
                  right: SizeConfig.instance.safeBlockHorizontal *
                      kOnboardingHorizontalPaddingBlocks,
                  top: SizeConfig.instance.safeBlockVertical * 1.5,
                  bottom: SizeConfig.instance.safeBlockVertical * 1.5,
                ),
                child: Text(
                  "Connect with members in an existing group. You can still connect with others even if you are not in a group. You can also join a group later.",
                  style: bodyTextStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: SizeConfig.instance.safeBlockHorizontal *
                      kOnboardingHorizontalPaddingBlocks,
                  right: SizeConfig.instance.safeBlockHorizontal *
                      kOnboardingHorizontalPaddingBlocks,
                  bottom: SizeConfig.instance.safeBlockVertical,
                ),
                child: Text(
                  'Groups',
                  style: subtitleTextStyle.apply(
                    color: Palette.titleColor,
                    fontWeightDelta: 3,
                  ),
                ),
              ),
              Expanded(
                child: BlocBuilder<OnboardingBloc, OnboardingState>(
                  builder: (BuildContext context, OnboardingState state) {
                    if (state is OnboardingGroups) {
                      final groups = state.groups;
                      final joined = state.joined;

                      return ListView.builder(
                        itemCount: groups?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          final group = groups[index];

                          return Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  width: 0.5,
                                  color: Palette.borderSeparatorColor,
                                ),
                                bottom: BorderSide(
                                  width: 0.5,
                                  color: Palette.borderSeparatorColor,
                                ),
                              ),
                            ),
                            padding: EdgeInsets.only(
                              left: SizeConfig.instance.safeBlockHorizontal *
                                  kOnboardingHorizontalPaddingBlocks,
                              right: SizeConfig.instance.safeBlockHorizontal *
                                  kOnboardingHorizontalPaddingBlocks,
                              top: 5,
                              bottom: 5,
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: AppLogo(
                                size: 50,
                              ),
                              title: Text(
                                group.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .apply(fontWeightDelta: 1),
                              ),
                              subtitle: Text(
                                group.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: SizedBox(
                                width: 80,
                                child: FlatButton(
                                  onPressed: () {
                                    if (!(joined[index])) {
                                      if (group.type == 'private') {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AccessCodeDialog());
                                      } else {
                                        BlocProvider.of<OnboardingBloc>(context)
                                            .add(JoinGroup(groupId: group.id));
                                      }
                                    }
                                  },
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 1,
                                      color: Palette.primaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  color: joined[index]
                                      ? Palette.primaryColor
                                      : Colors.transparent,
                                  child: Text(
                                    joined[index] ? 'Joined' : 'Join',
                                    style: buttonTextStyle.apply(
                                      fontWeightDelta: 1,
                                      color: joined[index]
                                          ? Palette.whiteColor
                                          : Palette.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }

                    return Center(
                      child: CupertinoActivityIndicator(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
