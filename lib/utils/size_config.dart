import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'constants.dart';

class SizeConfig {
  MediaQueryData _mediaQueryData;
  double screenWidth;
  double screenHeight;
  double blockSizeHorizontal;
  double blockSizeVertical;

  double _safeAreaHorizontal;
  double _safeAreaVertical;
  double safeBlockHorizontal;
  double safeBlockVertical;

  double safeScreenHeight;
  double scaffoldBodyHeight;

  double paddingTop;
  double paddingBottom;

  double appBarHeight;
  double searchBarHeightRatio;

  static final SizeConfig instance = SizeConfig._();

  SizeConfig._();

  void init(BuildContext context) {
    if (_mediaQueryData != null) {
      return;
    }

    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;

    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    paddingTop = _mediaQueryData.padding.top;
    paddingBottom = _mediaQueryData.padding.bottom;

    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;

    safeScreenHeight = screenHeight - _safeAreaVertical;
    scaffoldBodyHeight = screenHeight -
        _safeAreaVertical -
        kToolbarHeight -
        kBottomNavigationBarHeight +
        (kBottomNavigationBarFontSize / 2);

    if (Platform.isIOS) {
      // TODO: set kToolbarHeight for iPhones without status bar (iPhone 8 and below)
      appBarHeight = kAppBarHeight;
      searchBarHeightRatio = kSearchBarHeightRatioWithStatusBar;
    } else {
      appBarHeight = kToolbarHeight;
      searchBarHeightRatio = kSearchBarHeightRatio;
    }
  }
}
