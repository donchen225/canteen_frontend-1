import 'package:canteen_frontend/screens/profile/profile_text_card.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class EditProfileInterestsScreen extends StatefulWidget {
  final List<String> initialItems;
  final String fieldName;
  final Function onComplete;
  final Function onCancelNavigation;
  final Function onCompleteNavigation;

  EditProfileInterestsScreen({
    @required this.fieldName,
    @required this.onComplete,
    @required this.onCancelNavigation,
    @required this.onCompleteNavigation,
    this.initialItems,
  });

  _EditProfileInterestsScreenState createState() =>
      _EditProfileInterestsScreenState();
}

class _EditProfileInterestsScreenState
    extends State<EditProfileInterestsScreen> {
  List<String> interests;
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();

    interests = widget.initialItems;
    _textController = TextEditingController();
    _textController.addListener(_onTextChange);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onTextChange() {
    setState(() {});
  }

  Widget _createInterestWidget(String interestText) {
    return GestureDetector(
      onTap: () {
        setState(() {
          interests.remove(interestText);
        });
      },
      child: Container(
        padding: EdgeInsets.only(
          left: SizeConfig.instance.blockSizeHorizontal * 2,
          right: SizeConfig.instance.blockSizeHorizontal * 2,
          top: SizeConfig.instance.blockSizeHorizontal * 1.5,
          bottom: SizeConfig.instance.blockSizeHorizontal * 1.5,
        ),
        margin: EdgeInsets.only(
          top: SizeConfig.instance.blockSizeVertical,
          bottom: SizeConfig.instance.blockSizeVertical,
          right: SizeConfig.instance.blockSizeHorizontal * 3,
        ),
        decoration: BoxDecoration(
          color: Palette.orangeColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '#' + interestText,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: SizeConfig.instance.blockSizeHorizontal,
              ),
              child: Icon(
                Icons.cancel,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                if (widget.initialItems != interests) {
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
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 40),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 5),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey[400]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _textController,
                autofocus: true,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    decoration: TextDecoration.none),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter an interest',
                  counterText: '',
                  suffix: GestureDetector(
                      onTap: () {
                        setState(() {
                          interests.add(_textController.text);
                          _textController.clear();
                        });
                      },
                      child: Text(
                        'Add',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: _textController.text.length > 1
                              ? Palette.orangeColor
                              : Colors.grey,
                        ),
                      )),
                ),
                maxLength: 30,
                maxLines: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.instance.blockSizeVertical * 3),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ProfileTextCard(
                      height: SizeConfig.instance.blockSizeVertical * 30,
                      child: Wrap(
                        children: interests.map(_createInterestWidget).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
