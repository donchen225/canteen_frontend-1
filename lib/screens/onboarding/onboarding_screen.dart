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
    bubbleBackgroundColor: Colors.transparent,
    body: Text(
      'Easy  cab  booking  at  your  doorstep  with  cashless  payment  system',
    ),
    title: Text('Cabs'),
    mainImage: Image.asset(
      'assets/icon.jpeg',
      height: 285.0,
      width: 285.0,
      alignment: Alignment.center,
    ),
    titleTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
    bodyTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
  );

  @override
  Widget build(BuildContext context) {
    return IntroViewsFlutter(
      [page],
      onTapDoneButton: () {
        BlocProvider.of<HomeBloc>(context).add(PageTapped(index: 0));
      },
      showSkipButton: true,
      pageButtonTextStyles: TextStyle(
        color: Colors.white,
        fontSize: 18.0,
        fontFamily: "Regular",
      ),
    );
  }
}
