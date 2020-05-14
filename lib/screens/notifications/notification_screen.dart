import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        title: Text(
          'Notifications',
          style: Theme.of(context).textTheme.headline6.apply(
                fontFamily: '.SF UI Text',
                color: Palette.appBarTextColor,
              ),
        ),
        backgroundColor: Palette.appBarBackgroundColor,
        automaticallyImplyLeading: false,
        elevation: 1,
      ),
    );
  }
}
