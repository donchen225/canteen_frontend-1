import 'package:canteen_frontend/components/dialog_screen.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

import 'dart:math' as math;

class TextDialogScreen extends StatelessWidget {
  final String title;
  final double height;
  final Widget sendWidget;
  final Widget child;

  TextDialogScreen(
      {this.title, this.sendWidget, this.height = 500, this.child});

  @override
  Widget build(BuildContext context) {
    final double additionalTopPadding =
        math.max(SizeConfig.instance.paddingTop, 0.0);
    final double additionalBottomPadding =
        math.max(SizeConfig.instance.paddingBottom, 0.0);

    return DialogScreen(
      sendWidget: sendWidget,
      child: SingleChildScrollView(
        child: Container(
          height: height -
              kToolbarHeight -
              additionalTopPadding -
              kBottomNavigationBarHeight -
              additionalBottomPadding,
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(
                      top: SizeConfig.instance.blockSizeVertical * 2,
                      left: SizeConfig.instance.blockSizeHorizontal * 6,
                      right: SizeConfig.instance.blockSizeHorizontal * 6,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          width: 1,
                          color: const Color(0xFFDEE0D1),
                        ),
                      ),
                    ),
                    child: child ?? Container(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
