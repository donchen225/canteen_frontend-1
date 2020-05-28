import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/material.dart';

class EditProfileLongInfoScreen extends StatefulWidget {
  final String initialText;
  final String fieldName;
  final Function onComplete;
  final Function onCancelNavigation;
  final Function onCompleteNavigation;

  EditProfileLongInfoScreen({
    @required this.fieldName,
    @required this.onComplete,
    @required this.onCancelNavigation,
    @required this.onCompleteNavigation,
    this.initialText,
  });

  _EditProfileLongInfoScreenState createState() =>
      _EditProfileLongInfoScreenState();
}

class _EditProfileLongInfoScreenState extends State<EditProfileLongInfoScreen> {
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
                  color: Palette.primaryColor,
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
                  color: Palette.primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.25,
          padding: EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 5),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey[400]),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: _textController,
            textCapitalization: TextCapitalization.sentences,
            autofocus: true,
            style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                decoration: TextDecoration.none),
            decoration: InputDecoration(border: InputBorder.none),
            keyboardType: TextInputType.multiline,
            maxLength:
                300, // TODO: move character counter to bottom right corner of container
            maxLines: null,
          ),
        ),
      ),
    );
  }
}
