import 'package:canteen_frontend/screens/home/bloc/bloc.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';

class OnboardingSignUpScreens extends StatelessWidget {
  final page = new PageViewModel(
    pageColor: Palette.backgroundColor,
    // iconImageAssetPath: 'assets/taxi-driver.png',
    iconColor: null,
    bubbleBackgroundColor: Palette.orangeColor,
    body: Visibility(
      visible: false,
      child: Container(
        color: Colors.red,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              'Easy  cab  booking  at  your  doorstep  with  cashless  payment  system',
            ),
          ],
        ),
      ),
    ),
    title: Visibility(visible: false, child: Container()),
    mainImage: Container(
      color: Colors.red,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            'Easy  cab  booking  at  your  doorstep  with  cashless  payment  system',
          ),
        ],
      ),
    ),
    titleTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
    bodyTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
  );

  @override
  Widget build(BuildContext context) {
    return IntroViewsFlutter(
      [page, page, page, page, page, page],
      onTapDoneButton: () {
        BlocProvider.of<HomeBloc>(context).add(PageTapped(index: 0));
      },
      showNextButton: true,
      showSkipButton: false,
      nextText: Container(
          margin: EdgeInsets.all(SizeConfig.instance.blockSizeHorizontal * 3),
          height: SizeConfig.instance.blockSizeHorizontal * 12,
          width: SizeConfig.instance.blockSizeHorizontal * 12,
          decoration: BoxDecoration(
            color: Palette.orangeColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_forward_ios,
            size: SizeConfig.instance.blockSizeHorizontal * 5,
            color: Palette.whiteColor,
          )),
      pageButtonTextStyles: TextStyle(
        color: Colors.white,
        fontSize: 18.0,
        fontFamily: "Regular",
      ),
    );
  }
}
