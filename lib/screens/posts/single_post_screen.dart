import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SinglePostScreen extends StatelessWidget {
  final Widget body;
  final Function onTapBack;

  SinglePostScreen({Key key, @required this.body, this.onTapBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: AppBar(
        backgroundColor: Palette.containerColor,
        elevation: 1,
        leading: BackButton(
          color: Palette.primaryColor,
          onPressed: () {
            Navigator.of(context).maybePop(true);

            if (onTapBack != null) {
              onTapBack();
            }
          },
        ),
        title: Text('Post', style: Theme.of(context).textTheme.headline6),
      ),
      body: body,
    );
  }
}
