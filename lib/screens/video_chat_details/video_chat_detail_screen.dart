import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class VideoChatDetailScreen extends StatefulWidget {
  _VideoChatDetailScreenState createState() => _VideoChatDetailScreenState();
}

class _VideoChatDetailScreenState extends State<VideoChatDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: <Widget>[
        Container(
          height: SizeConfig.instance.blockSizeVertical * 30,
          child: Center(
            child: Text('DATETIME PICKER'),
          ),
        ),
      ]),
    );
  }
}
