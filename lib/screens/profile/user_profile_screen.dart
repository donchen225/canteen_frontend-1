import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/match/match_bloc/bloc.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/screens/profile/update_name_field.dart';
import 'package:canteen_frontend/screens/profile/user_profile_bloc/bloc.dart';
import 'package:canteen_frontend/services/firebase_storage.dart';
import 'package:canteen_frontend/shared_blocs/authentication/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileScreen extends StatefulWidget {
  final UserRepository _userRepository;

  UserProfileScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  File _imageFile;
  ImageProvider _profilePicture;

  @override
  void initState() {
    super.initState();

    _profilePicture = AssetImage('assets/blank-profile-picture.jpeg');
  }

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (context, state) {
      if (state is UserProfileLoading) {
        return Center(child: CircularProgressIndicator());
      }

      if (state is UserProfileLoaded) {
        final user = state.user;

        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(
              'Profile',
            ),
            elevation: 2,
            automaticallyImplyLeading: false,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.exit_to_app),
                color: Colors.black,
                onPressed: () {
                  BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                  BlocProvider.of<MatchBloc>(context).add(ClearMatches());
                },
              )
              // IconButton(
              //   icon: Icon(Icons.settings),
              //   onPressed: () {
              //     _scaffoldKey.currentState.openEndDrawer();
              //   },
              // )
            ],
          ),
          body: ListView(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 10, bottom: 20),
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            showCupertinoModalPopup(
                              context: context,
                              builder: (BuildContext context) =>
                                  CupertinoActionSheet(
                                title: Text(
                                  'Change Profile Photo',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                                actions: <Widget>[
                                  // TODO: implement this
                                  CupertinoActionSheetAction(
                                    onPressed: () {},
                                    child: Text(
                                      'Remove Current Photo',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                  CupertinoActionSheetAction(
                                    onPressed: () =>
                                        _pickImage(ImageSource.camera)
                                            .then((nothing) async {
                                      setState(() {
                                        _profilePicture = FileImage(_imageFile);
                                      });
                                      CloudStorage()
                                          .upload(_imageFile, user.id)
                                          .then((task) async {
                                        final downloadUrl =
                                            (await task.onComplete);
                                        final String url = (await downloadUrl
                                            .ref
                                            .getDownloadURL());
                                        widget._userRepository
                                            .updatePhoto(user.id, url);
                                      });
                                    }),
                                    child: Text(
                                      'Take Photo',
                                    ),
                                  ),
                                  CupertinoActionSheetAction(
                                    onPressed: () =>
                                        _pickImage(ImageSource.gallery)
                                            .then((nothing) async {
                                      setState(() {
                                        _profilePicture = FileImage(_imageFile);
                                      });
                                      CloudStorage()
                                          .upload(_imageFile, user.id)
                                          .then((task) async {
                                        final downloadUrl =
                                            (await task.onComplete);
                                        final String url = (await downloadUrl
                                            .ref
                                            .getDownloadURL());
                                        widget._userRepository
                                            .updatePhoto(user.id, url);
                                      });
                                    }),
                                    child: Text(
                                      'Choose from Library',
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          child: ProfilePicture(
                            photoUrl: user.photoUrl,
                            localPicture: _profilePicture,
                            editable: true,
                            size: 160,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      user.displayName ?? '',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: UpdateNameForm(userRepository: widget._userRepository),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Want to learn',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}
