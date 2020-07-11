import 'package:canteen_frontend/components/cancel_button.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

import 'dart:math' as math;

class DialogScreen extends StatelessWidget {
  final String title;
  final double height;
  final Widget sendWidget;
  final Widget child;
  final Function onCancel;

  DialogScreen(
      {this.title = '',
      this.sendWidget,
      this.height = 500,
      this.onCancel,
      this.child});

  @override
  Widget build(BuildContext context) {
    final double additionalTopPadding =
        math.max(SizeConfig.instance.paddingTop, 0.0);

    return Scaffold(
      backgroundColor: const Color(0xFFFEFFFF),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kAppBarHeight + additionalTopPadding),
        child: SafeArea(
          child: AppBar(
            backgroundColor: const Color(0xFFFEFFFF),
            flexibleSpace: Container(
              padding: EdgeInsets.only(
                top: additionalTopPadding,
                left: SizeConfig.instance.safeBlockHorizontal * 5,
                right: SizeConfig.instance.safeBlockHorizontal * 5,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CancelButton(
                    onTap: (BuildContext context) {
                      if (onCancel != null) {
                        onCancel();
                      } else {
                        Navigator.of(context).maybePop(false);
                      }
                    },
                  ),
                  Text(title, style: Theme.of(context).textTheme.headline6),
                  sendWidget != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            sendWidget,
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(15),
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
        child: child ?? Container(),
      ),
    );
  }
}
