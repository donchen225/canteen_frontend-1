import 'package:canteen_frontend/screens/home/bloc/bloc.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingCompleteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.instance.blockSizeHorizontal * 9),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  Text("1. Check your recommendations."),
                  Text("2. Search for people you want to talk to."),
                  Text("3. Send a request."),
                  Text("4. Video chat and make money.")
                ],
              ),
            ),
          ),
          Flexible(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: SizeConfig.instance.safeBlockVertical * 9,
                    width: SizeConfig.instance.safeBlockHorizontal * 42,
                    child: RaisedButton(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      onPressed: () {
                        BlocProvider.of<HomeBloc>(context)
                            .add(PageTapped(index: 0));
                      },
                      color: Palette.orangeColor,
                      child: Text(
                        'Continue',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
