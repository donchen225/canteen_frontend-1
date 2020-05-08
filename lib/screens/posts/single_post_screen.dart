import 'package:flutter/material.dart';

class SinglePostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: CustomScrollView(),
          ),
          Container(),
        ],
      ),
    );
  }
}
