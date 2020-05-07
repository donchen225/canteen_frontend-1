import 'package:canteen_frontend/screens/posts/enter_post_box.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        title: Text(
          'Home',
          style: TextStyle(
            color: Color(0xFF303030),
          ),
        ),
        backgroundColor: Palette.appBarBackgroundColor,
        elevation: 1,
      ),
      body: ListView(
        padding: EdgeInsets.only(top: SizeConfig.instance.blockSizeVertical),
        children: <Widget>[
          EnterPostBox(),
        ],
      ),
    );
  }
}
