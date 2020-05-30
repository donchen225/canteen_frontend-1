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
      {@required this.title, this.sendWidget, this.height = 500, this.child});

  @override
  Widget build(BuildContext context) {
    final double additionalTopPadding =
        math.max(SizeConfig.instance.paddingTop, 0.0);

    return Scaffold(
      backgroundColor: const Color(0xFFFEFFFF),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + additionalTopPadding),
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
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).maybePop();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: height,
                      child: Text('Cancel',
                          style: Theme.of(context)
                              .textTheme
                              .button
                              .apply(color: Palette.primaryColor)),
                    ),
                  ),
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
        child: SingleChildScrollView(
          child: Container(
            height: height - kToolbarHeight,
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
      ),
    );
  }
}
