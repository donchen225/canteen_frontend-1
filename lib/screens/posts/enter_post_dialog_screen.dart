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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: const Color(0xFFFEFFFF),
          leading: CloseButton(),
          title: Text('New Question'),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(15),
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
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
                        children: <Widget>[
                          Text('Brian Hsu asked'),
                        ],
                      ),
                      TextField(
                        controller: _textController,
                        autofocus: true,
                        maxLines: null,
                        decoration:
                            InputDecoration(hintText: 'Add your question'),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: SizeConfig.instance.blockSizeVertical,
                    bottom: SizeConfig.instance.blockSizeVertical,
                    left: SizeConfig.instance.blockSizeHorizontal * 3,
                    right: SizeConfig.instance.blockSizeHorizontal * 3),
                child: Row(
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
