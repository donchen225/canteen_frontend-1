import 'package:canteen_frontend/screens/profile/user_profile_bloc/bloc.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  UserProfileBloc _userProfileBloc;
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();

    _userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
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
            autofocus: true,
            style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                decoration: TextDecoration.none),
            decoration: InputDecoration(border: InputBorder.none),
            keyboardType: TextInputType.multiline,
            maxLength:
                150, // TODO: move character counter to bottom right corner of container
            maxLines: null,
          ),
        ),
      ),
    );
  }
}
