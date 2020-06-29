import 'package:canteen_frontend/components/confirm_button.dart';
import 'package:canteen_frontend/components/dialog_screen.dart';
import 'package:canteen_frontend/components/interest_item.dart';
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
  List<String> interests = [];
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();

    interests.addAll(widget.initialItems ?? []);
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

  @override
  Widget build(BuildContext context) {
    return DialogScreen(
      title: 'Edit ${widget.fieldName}',
      onCancel: () => widget.onCancelNavigation(),
      sendWidget: ConfirmButton(
        onTap: (_) {
          if (widget.initialItems != interests) {
            widget.onComplete(interests);
          } else {
            widget.onCompleteNavigation();
          }
        },
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 40),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 5),
              decoration: BoxDecoration(
                color: Palette.containerColor,
                border:
                    Border.all(width: 1, color: Palette.borderSeparatorColor),
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
                              ? Palette.primaryColor
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
                        children: interests
                            .map((text) => Padding(
                                  padding: EdgeInsets.only(
                                      right: SizeConfig
                                              .instance.blockSizeHorizontal *
                                          3),
                                  child: InterestItem(
                                    text: text,
                                    onTap: (String interestText) {
                                      setState(() {
                                        interests.remove(interestText);
                                      });
                                    },
                                  ),
                                ))
                            .toList(),
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
