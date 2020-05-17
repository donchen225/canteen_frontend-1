import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/material.dart';

class DiscoverGroupScreen extends StatelessWidget {
  final Function onTapBack;

  DiscoverGroupScreen({this.onTapBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discover'),
        backgroundColor: Palette.appBarBackgroundColor,
        elevation: 0,
        leading: BackButton(
          onPressed: () {
            if (onTapBack != null) {
              onTapBack();
            }
          },
        ),
      ),
    );
  }
}
