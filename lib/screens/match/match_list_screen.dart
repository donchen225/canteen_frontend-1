import 'package:canteen_frontend/screens/match/match_list.dart';
import 'package:flutter/material.dart';

class MatchListScreen extends StatelessWidget {
  MatchListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Matches',
        ),
        automaticallyImplyLeading: false,
        elevation: 2,
      ),
      body: MatchList(),
    );
  }
}
