import 'package:canteen_frontend/components/dialog_screen.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class TextDialogScreen extends StatelessWidget {
  final String title;
  final Widget sendWidget;
  final bool canUnfocus;
  final bool hasPadding;
  final Widget child;

  TextDialogScreen(
      {this.title,
      this.sendWidget,
      this.canUnfocus = true,
      this.hasPadding = true,
      this.child});

  @override
  Widget build(BuildContext context) {
    return DialogScreen(
      sendWidget: sendWidget,
      canUnfocus: canUnfocus,
      child: Padding(
        padding: EdgeInsets.only(
          top: SizeConfig.instance.safeBlockVertical * (hasPadding ? 2 : 0),
        ),
        child: child ?? Container(),
      ),
    );
  }
}
