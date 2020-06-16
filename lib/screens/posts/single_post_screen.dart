import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SinglePostScreen extends StatelessWidget {
  static const routeName = '/post';
  final Widget body;

  SinglePostScreen({@required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.containerColor,
        elevation: 1,
        leading: BackButton(
          color: Palette.primaryColor,
        ),
        title: Text('Post', style: Theme.of(context).textTheme.headline6),
      ),
      body: body,
    );
  }
}
