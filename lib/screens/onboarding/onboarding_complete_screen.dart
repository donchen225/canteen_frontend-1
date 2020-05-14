import 'package:canteen_frontend/components/main_button.dart';
import 'package:canteen_frontend/screens/home/bloc/bloc.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingCompleteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final buttonFontStyle = Theme.of(context).textTheme.headline5;
    final textFontStyle = Theme.of(context).textTheme.subtitle1;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.instance.safeBlockHorizontal *
              kLandingHorizontalPaddingBlocks,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.instance.blockSizeVertical * 3),
                    child: Text(
                      "Profiles with unique experiences and skills lead to beter convos.",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Text(
                    "How to use Canteen:",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "1. Check your recommendations.",
                    style: textFontStyle,
                  ),
                  Text(
                    "2. Search for people you want to talk to.",
                    style: textFontStyle,
                  ),
                  Text(
                    "3. Send a request.",
                    style: textFontStyle,
                  ),
                  Text(
                    "4. Video chat and make money.",
                    style: textFontStyle,
                  )
                ],
              ),
            ),
            Flexible(
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: MainButton(
                            height: SizeConfig.instance.safeBlockHorizontal *
                                (100 - (2 * kLandingHorizontalPaddingBlocks)) /
                                kButtonAspectRatio,
                            onPressed: () {
                              BlocProvider.of<HomeBloc>(context)
                                  .add(InitializeHome());
                            },
                            color: Palette.orangeColor,
                            text: 'Continue',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
