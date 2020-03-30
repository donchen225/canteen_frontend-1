import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/match/match_bloc/bloc.dart';
import 'package:canteen_frontend/screens/profile/update_name_field.dart';
import 'package:canteen_frontend/services/firebase_storage.dart';
import 'package:canteen_frontend/shared_blocs/authentication/bloc.dart';
import 'package:canteen_frontend/shared_blocs/user/bloc.dart';
import 'package:canteen_frontend/shared_blocs/user/user_bloc.dart';
import 'package:canteen_frontend/shared_blocs/user/user_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final UserRepository _userRepository;
  final User user;

  ProfileScreen({Key key, this.user, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  File _imageFile;
  ImageProvider _profilePicture;

  @override
  void initState() {
    super.initState();

    // TODO: add default profile url
    _profilePicture = AssetImage('assets/icon.png');
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
    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      final User user = (state as UserLoaded).user;

      return Scaffold(
        key: _scaffoldKey,
        // endDrawer: Container(
        //   width: MediaQuery.of(context).size.width * 0.5,
        //   child: Drawer(
        //     child: ListView(
        //       // Important: Remove any padding from the ListView.
        //       padding: EdgeInsets.zero,
        //       children: <Widget>[
        //         Container(
        //           height: 80,
        //           child: DrawerHeader(
        //             child: Text('Settings'),
        //             decoration: BoxDecoration(
        //               color: Colors.blue,
        //             ),
        //           ),
        //         ),
        //         ListTile(
        //           title: Text('Item 1'),
        //           onTap: () {},
        //         ),
        //         ListTile(
        //           title: Text('Item 2'),
        //           onTap: () {},
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        appBar: AppBar(
          title: Text(
            'Profile',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          elevation: 2,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.grey[200],
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              color: Colors.black,
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                BlocProvider.of<UserBloc>(context).add(LogOutUser());
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
            Padding(
              padding: EdgeInsets.only(top: 20, left: 10, bottom: 20),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) => CupertinoActionSheet(
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
                              onPressed: () => _pickImage(ImageSource.camera)
                                  .then((nothing) async {
                                setState(() {
                                  _profilePicture = FileImage(_imageFile);
                                });
                                CloudStorage()
                                    .upload(_imageFile, user.id)
                                    .then((task) async {
                                  final downloadUrl = (await task.onComplete);
                                  final String url =
                                      (await downloadUrl.ref.getDownloadURL());
                                  widget._userRepository
                                      .updatePhoto(user.id, url);
                                });
                              }),
                              child: Text(
                                'Take Photo',
                              ),
                            ),
                            CupertinoActionSheetAction(
                              onPressed: () => _pickImage(ImageSource.gallery)
                                  .then((nothing) async {
                                setState(() {
                                  _profilePicture = FileImage(_imageFile);
                                });
                                CloudStorage()
                                    .upload(_imageFile, user.id)
                                    .then((task) async {
                                  final downloadUrl = (await task.onComplete);
                                  final String url =
                                      (await downloadUrl.ref.getDownloadURL());
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
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: (user.photoUrl != null &&
                                  user.photoUrl.isNotEmpty)
                              ? CachedNetworkImageProvider(user.photoUrl)
                              : AssetImage('assets/blank-profile-picture.jpeg'),
                          fit: BoxFit.cover,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: Colors.white,
                            ),
                            color: Colors.blue[500],
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            CupertinoIcons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text('Games'),
                            Text('Played'),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                '0',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text('Quizzes'),
                            Text('Won'),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                '0',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text('Questions'),
                            Text('Answered'),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                '0',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    user.displayName ?? '',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                'Favorite Questions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    });
  }
}
