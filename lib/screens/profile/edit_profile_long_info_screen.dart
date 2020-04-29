import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/profile/user_profile_bloc/bloc.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileLongInfoScreen extends StatefulWidget {
  final User user;
  final String field;

  EditProfileLongInfoScreen({@required this.user, @required this.field});

  _EditProfileLongInfoScreenState createState() =>
      _EditProfileLongInfoScreenState();
}

class _EditProfileLongInfoScreenState extends State<EditProfileLongInfoScreen> {
  UserProfileBloc _userProfileBloc;
  TextEditingController _textController;
  String fieldName;

  @override
  void initState() {
    super.initState();
    fieldName = widget.field[0].toUpperCase() + widget.field.substring(1);

    _userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.field == 'about') {
      _textController.text = widget.user.about;
    } else if (widget.field == 'name') {
      _textController.text = widget.user.displayName;
    }

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
                _userProfileBloc.add(LoadUserProfile(widget.user));
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
            Text('Edit ' + fieldName),
            GestureDetector(
              onTap: () {
                if (widget.field == 'about') {
                  if (widget.user.about != _textController.text) {
                    _userProfileBloc
                        .add(UpdateAboutSection(_textController.text));
                  } else {
                    _userProfileBloc.add(LoadUserProfile(widget.user));
                  }
                } else if (widget.field == 'name') {
                  if (widget.user.displayName != _textController.text) {
                    _userProfileBloc.add(UpdateName(_textController.text));
                  } else {
                    _userProfileBloc.add(LoadUserProfile(widget.user));
                  }
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
