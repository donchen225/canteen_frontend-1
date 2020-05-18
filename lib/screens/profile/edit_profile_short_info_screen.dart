import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class EditProfileShortInfoScreen extends StatefulWidget {
  final String initialText;
  final String fieldName;
  final Function onComplete;
  final Function onCancelNavigation;
  final Function onCompleteNavigation;

  EditProfileShortInfoScreen({
    @required this.fieldName,
    @required this.onComplete,
    @required this.onCancelNavigation,
    @required this.onCompleteNavigation,
    this.initialText,
  });

  _EditProfileShortInfoScreenState createState() =>
      _EditProfileShortInfoScreenState();
}

class _EditProfileShortInfoScreenState
    extends State<EditProfileShortInfoScreen> {
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();

    _textController = TextEditingController();
    _textController.text = widget.initialText ?? '';
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.containerColor,
      appBar: AppBar(
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
        backgroundColor: Palette.appBarBackgroundColor,
        elevation: 1,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                widget.onCancelNavigation();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 14,
                  color: Palette.orangeColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text('Edit ' + widget.fieldName),
            GestureDetector(
              onTap: () {
                if (widget.initialText != _textController.text) {
                  widget.onComplete(_textController.text);
                } else {
                  widget.onCompleteNavigation();
                }
              },
              child: Text(
                'Done',
                style: TextStyle(
                  fontSize: 14,
                  color: Palette.orangeColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.25,
        padding: EdgeInsets.only(
            top: SizeConfig.instance.blockSizeVertical * 6,
            left: SizeConfig.instance.blockSizeHorizontal * 6,
            right: SizeConfig.instance.blockSizeHorizontal * 6,
            bottom: SizeConfig.instance.blockSizeVertical * 6),
        child: TextField(
          controller: _textController,
          textCapitalization: TextCapitalization.sentences,
          autofocus: true,
          style: TextStyle(
              fontSize: SizeConfig.instance.blockSizeHorizontal * 7,
              fontWeight: FontWeight.w600,
              color: Palette.orangeColor,
              decoration: TextDecoration.none),
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            counterText: '',
          ),
          keyboardType: TextInputType.multiline,
          maxLength: 80,
          maxLines: 1,
        ),
      ),
    );
  }
}
