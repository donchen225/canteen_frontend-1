import 'package:canteen_frontend/screens/match/match_list.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/material.dart';

class MatchListScreen extends StatelessWidget {
  MatchListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        title: Text(
          'Matches',
          style: TextStyle(
            color: Color(0xFF303030),
          ),
        ),
        backgroundColor: Palette.appBarBackgroundColor,
        automaticallyImplyLeading: false,
        elevation: 1,
      ),
      body: MatchList(),
    );
  }
}
