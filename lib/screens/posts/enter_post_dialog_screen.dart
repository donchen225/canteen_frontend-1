import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class EnterPostDialogScreen extends StatefulWidget {
  EnterPostDialogScreen();

  @override
  _EnterPostDialogScreenState createState() => _EnterPostDialogScreenState();
}

class _EnterPostDialogScreenState extends State<EnterPostDialogScreen> {
  TextEditingController _textController;

  _EnterPostDialogScreenState();

  @override
  void initState() {
    super.initState();

    _textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.instance.blockSizeVertical * 90,
      decoration: BoxDecoration(
        color: const Color(0xFFFEFFFF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: SizeConfig.instance.blockSizeVertical * 2,
              bottom: SizeConfig.instance.blockSizeVertical * 2,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFEFFFF),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'New Question',
                  style:
                      TextStyle(fontSize: 18, color: const Color(0xFF939598)),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: SizeConfig.instance.blockSizeVertical * 3,
              left: SizeConfig.instance.blockSizeHorizontal * 3,
              right: SizeConfig.instance.blockSizeHorizontal * 3,
            ),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 1,
                  color: const Color(0xFFDEE0D1),
                ),
                bottom: BorderSide(
                  width: 1,
                  color: const Color(0xFFDEE0D1),
                ),
              ),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[Text('Brian Hsu asked')],
                ),
                TextField(
                  controller: _textController,
                  maxLines: null,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton(
                      color: Palette.orangeColor,
                      child: Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: _textController.text.isNotEmpty ? () {} : null,
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
