import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

import 'dart:math' as math;

class OnboardingScreen extends StatefulWidget {
  final Widget child;
  final Widget next;
  final Function onSkip;
  final List<FocusNode> nodes;
  final bool horizontalPadding;

  OnboardingScreen(
      {this.child,
      this.next,
      this.onSkip,
      this.nodes,
      this.horizontalPadding = true});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  double additionalBottomPadding = 0;

  void initState() {
    super.initState();

    additionalBottomPadding = math.max(SizeConfig.instance.paddingBottom, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final buttonTextStyle = Theme.of(context).textTheme.button;

    if (widget.nodes != null && widget.nodes.isNotEmpty) {
      additionalBottomPadding = widget.nodes.any((node) => node.hasFocus)
          ? 0
          : math.max(SizeConfig.instance.paddingBottom, 0.0);
    } else {
      additionalBottomPadding =
          math.max(SizeConfig.instance.paddingBottom, 0.0);
    }

    return Scaffold(
      backgroundColor: Palette.scaffoldBackgroundLightColor,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kAppBarHeight),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Container(
            height: kAppBarHeight - 10,
            width: kAppBarHeight - 10,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/loading-icon.png'),
              ),
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: widget.horizontalPadding
                    ? EdgeInsets.only(
                        left: SizeConfig.instance.safeBlockHorizontal *
                            kOnboardingHorizontalPaddingBlocks,
                        right: SizeConfig.instance.safeBlockHorizontal *
                            kOnboardingHorizontalPaddingBlocks,
                      )
                    : EdgeInsets.zero,
                child: widget.child ?? Container(),
              ),
            ),
            SafeArea(
              child: Container(
                padding: EdgeInsets.only(bottom: additionalBottomPadding),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                    width: 1,
                    color: Palette.borderSeparatorColor,
                  ))),
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.instance.safeBlockHorizontal *
                        kOnboardingHorizontalPaddingBlocks,
                  ),
                  height: kBottomNavigationBarHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (widget.onSkip != null) {
                            widget.onSkip();
                          }
                        },
                        child: Text(
                          'Skip for now',
                          style: buttonTextStyle.apply(
                            color: Palette.primaryColor,
                          ),
                        ),
                      ),
                      widget.next ?? Container(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
