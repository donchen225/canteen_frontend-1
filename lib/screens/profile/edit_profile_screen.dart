import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/profile/user_profile_bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  EditProfileScreen({@required this.user});

  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  UserProfileBloc _userProfileBloc;
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();

    _userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    _textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    _textController.text = widget.user.about;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                style: TextStyle(fontSize: 14),
              ),
            ),
            Text('Edit About'),
            GestureDetector(
              onTap: () {
                if (widget.user.about != _textController.text) {
                  _userProfileBloc.add(
                      UpdateAboutSection(widget.user, _textController.text));
                } else {
                  _userProfileBloc.add(LoadUserProfile(widget.user));
                }
              },
              child: Text(
                'Done',
                style: TextStyle(fontSize: 14),
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
