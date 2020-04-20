import 'package:canteen_frontend/screens/home/bloc/bloc.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';

class OnboardingSignUpScreens extends StatelessWidget {
  final namePage = new PageViewModel(
    pageColor: Palette.backgroundColor,
    // iconImageAssetPath: 'assets/taxi-driver.png',
    iconColor: null,
    bubbleBackgroundColor: Palette.orangeColor,
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              child: Text("What's your name?"),
            ),
          ],
        ),
        TextField(
          style: TextStyle(
              fontSize: 25,
              color: Palette.orangeColor,
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.none),
          decoration: InputDecoration(
            counterText: "",
            contentPadding: EdgeInsets.all(0),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
          maxLines: 1,
          minLines: 1,
        ),
      ],
    ),
    bodyTextStyle: TextStyle(
        fontFamily: 'MyFont', color: Colors.black, fontWeight: FontWeight.w700),
  );
  final skillPage = new PageViewModel(
    pageColor: Palette.backgroundColor,
    // iconImageAssetPath: 'assets/taxi-driver.png',
    iconColor: null,
    bubbleBackgroundColor: Palette.orangeColor,
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.instance.blockSizeHorizontal * 6,
              ),
              child: Text(
                "What are your skills?",
              ),
            ),
          ],
        ),
      ],
    ),
    bodyTextStyle: TextStyle(
        fontFamily: 'MyFont', color: Colors.black, fontWeight: FontWeight.w700),
  );

  @override
  Widget build(BuildContext context) {
    return IntroViewsFlutter(
      [namePage, skillPage],
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
