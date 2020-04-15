import 'package:flutter/material.dart';

class RecommendedEmptyScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey[100],
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.instance.blockSizeHorizontal * 9),
                child: Center(
                  child: Text(
                    'Congrats on swiping your daily batch!',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.instance.blockSizeHorizontal * 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Didn't love your suggestions?",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'Update your skills to see completely different people next time!',
                        textAlign: TextAlign.center,
                      )
                    ],
                  )),
            ),
          ],
        ),
      );
  }
}