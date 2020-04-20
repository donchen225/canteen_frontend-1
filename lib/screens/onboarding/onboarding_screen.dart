import 'package:canteen_frontend/screens/home/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';

class OnboardingScreen extends StatelessWidget {
  final page = new PageViewModel(
    pageColor: const Color(0xFF607D8B),
    // iconImageAssetPath: 'assets/taxi-driver.png',
    iconColor: null,
    bubbleBackgroundColor: Colors.red,
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
      pageButtonTextStyles: TextStyle(
        color: Colors.white,
        fontSize: 18.0,
        fontFamily: "Regular",
      ),
    );
  }
}
