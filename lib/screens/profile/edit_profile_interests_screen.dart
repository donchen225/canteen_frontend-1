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
    return Container(
      padding: EdgeInsets.only(
        left: SizeConfig.instance.blockSizeHorizontal * 2,
        right: SizeConfig.instance.blockSizeHorizontal * 2,
        top: SizeConfig.instance.blockSizeHorizontal,
        bottom: SizeConfig.instance.blockSizeHorizontal,
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
      child: Text('#' + interestText),
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
        padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
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
                  suffix: GestureDetector(
                      onTap: () {
                        print('Tapped');
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
                maxLength:
                    150, // TODO: move character counter to bottom right corner of container
                maxLines: 1,
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: ProfileTextCard(
                    height: SizeConfig.instance.blockSizeVertical * 30,
                    child: Wrap(
                      children: <Widget>[
                        _createInterestWidget('MachineLearning'),
                        _createInterestWidget('MachineLearning'),
                        _createInterestWidget('MachineLearning'),
                        _createInterestWidget('MachineLearning'),
                        _createInterestWidget('MachineLearning'),
                        _createInterestWidget('MachineLearning'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
