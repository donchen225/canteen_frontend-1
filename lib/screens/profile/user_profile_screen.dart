import 'dart:io';

import 'package:canteen_frontend/components/profile_upload_sheet.dart';
import 'package:canteen_frontend/models/skill/skill_type.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/profile/add_icon.dart';
import 'package:canteen_frontend/screens/profile/edit_profile_screen.dart';
import 'package:canteen_frontend/screens/profile/edit_profile_skill.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/screens/profile/profile_section_title.dart';
import 'package:canteen_frontend/screens/profile/skill_list.dart';
import 'package:canteen_frontend/screens/profile/user_profile_bloc/bloc.dart';
import 'package:canteen_frontend/screens/settings/settings_screen.dart';
import 'package:canteen_frontend/services/firebase_storage.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
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
  ImageProvider _profilePicture =
      AssetImage('assets/blank-profile-picture.jpeg');
  UserProfileBloc _userProfileBloc;
  final double listPadding = 20;
  bool nameSelected = false;

  @override
  void initState() {
    super.initState();
    _userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
  }

  void showPopUpSheet(User user) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) =>
          ProfileUploadSheet(onUpload: (imageFile) {
        setState(() {
          _profilePicture = FileImage(imageFile);
        });
        // TODO: move this to BLoC
        CloudStorage().upload(imageFile, user.id).then((task) async {
          final downloadUrl = (await task.onComplete);
          final String url = (await downloadUrl.ref.getDownloadURL());
          widget._userRepository.updatePhoto(url);
        });
      }),
    );
  }

  Widget _buildUserProfile(UserProfileState state) {
    if (state is UserProfileLoaded) {
      final user = state.user;

      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          brightness: Brightness.light,
          title: Text(
            'Profile',
            style: TextStyle(
              color: Palette.appBarTextColor,
            ),
          ),
          backgroundColor: Palette.appBarBackgroundColor,
          elevation: 1,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              color: Palette.appBarTextColor,
              onPressed: () {
                BlocProvider.of<UserProfileBloc>(context).add(ShowSettings());
              },
            )
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
                          showPopUpSheet(user);
                        },
                        child: ProfilePicture(
                          photoUrl: user.photoUrl,
                          localPicture: _profilePicture,
                          editable: true,
                          size: 160,
                          onTap: () => showPopUpSheet(user),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: listPadding, right: listPadding),
              child: ProfileSectionTitle('About'),
            ),
            GestureDetector(
              onTap: () {
                _userProfileBloc.add(EditAboutSection(user));
              },
              child: Padding(
                padding: EdgeInsets.only(left: listPadding, right: listPadding),
                child: Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey[200]),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  margin: EdgeInsets.all(0),
                  elevation: 0.3,
                  color: Colors.white,
                  child: Container(
                    height: 100,
                    padding: EdgeInsets.all(15),
                    child: Text(user.about ?? ''),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: listPadding, right: listPadding),
              child: ProfileSectionTitle("I'm teaching"),
            ),
            Padding(
              padding: EdgeInsets.only(left: listPadding, right: listPadding),
              child: SkillList(
                user.teachSkill,
                onTap: (int index) => _userProfileBloc
                    .add(EditSkill(user, SkillType.teach, index)),
              ),
            ),
            user.teachSkill.length < 3
                ? AddIcon(
                    160,
                    onTap: () {
                      _userProfileBloc.add(EditSkill(
                          user, SkillType.teach, user.teachSkill.length));
                    },
                  )
                : Container(),
            Padding(
              padding: EdgeInsets.only(left: listPadding, right: listPadding),
              child: ProfileSectionTitle("I'm learning"),
            ),
            Padding(
              padding: EdgeInsets.only(left: listPadding, right: listPadding),
              child: SkillList(
                user.learnSkill,
                onTap: (int index) => _userProfileBloc
                    .add(EditSkill(user, SkillType.learn, index)),
              ),
            ),
            user.learnSkill.length < 3
                ? Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: AddIcon(
                      160,
                      onTap: () {
                        _userProfileBloc.add(EditSkill(
                            user, SkillType.learn, user.learnSkill.length));
                      },
                    ),
                  )
                : Container(),
            Padding(
              padding: EdgeInsets.only(
                  left: listPadding, right: listPadding, top: 5, bottom: 10),
              child: Text('Basic Info'),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    nameSelected = true;
                  });
                },
                onTapCancel: () {
                  setState(() {
                    nameSelected = false;
                  });
                },
                onTap: () {
                  setState(() {
                    nameSelected = false;
                  });
                  _userProfileBloc.add(EditName(user));
                },
                child: Container(
                  padding: EdgeInsets.only(
                      left: listPadding,
                      right: listPadding + 5,
                      top: 5,
                      bottom: 5),
                  decoration: BoxDecoration(
                    color: nameSelected
                        ? Colors.grey[500].withOpacity(0.6)
                        : Colors.white,
                    border: Border(
                      top: BorderSide(width: 1, color: Colors.grey[400]),
                      bottom: BorderSide(width: 1, color: Colors.grey[400]),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Name',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          Text(user.displayName ?? '',
                              style: TextStyle(fontWeight: FontWeight.w400)),
                        ],
                      ),
                      Icon(Icons.keyboard_arrow_right)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (state is UserProfileEditingAbout) {
      return EditProfileScreen(
        user: state.user,
        field: 'about',
      );
    }

    if (state is UserProfileEditingSkill) {
      return EditProfileSkill(
          user: state.user,
          skillType: state.skillType,
          skillIndex: state.skillIndex);
    }

    if (state is UserProfileEditingName) {
      return EditProfileScreen(
        user: state.user,
        field: 'name',
      );
    }

    if (state is SettingsMenu) {
      return SettingsScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (context, state) {
      if (state is UserProfileLoading) {
        return Center(child: CupertinoActivityIndicator());
      } else {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: animationDuration),
          switchOutCurve: Threshold(0),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(offsetdX, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
          child: _buildUserProfile(state),
        );
      }
    });
  }
}
