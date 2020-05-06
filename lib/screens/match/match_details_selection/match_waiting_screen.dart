import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class MatchWaitingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: SizeConfig.instance.blockSizeVertical * 9,
                bottom: SizeConfig.instance.blockSizeVertical * 9,
                left: SizeConfig.instance.blockSizeHorizontal * 9,
                right: SizeConfig.instance.blockSizeHorizontal * 9,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    'Waiting for payment...',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  Icon(
                    Icons.schedule,
                    size: SizeConfig.instance.blockSizeHorizontal * 33,
                    color: Palette.orangeColor,
                  ),
                  Text(
                      "In order to ensure the quality of each connection, we don't allow any interactions until a payment is made."),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
