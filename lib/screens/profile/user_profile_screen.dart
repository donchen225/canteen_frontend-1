import 'package:canteen_frontend/components/profile_upload_sheet.dart';
import 'package:canteen_frontend/models/skill/skill_type.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/profile/add_icon.dart';
import 'package:canteen_frontend/screens/profile/basic_info_tab.dart';
import 'package:canteen_frontend/screens/profile/edit_profile_long_info_screen.dart';
import 'package:canteen_frontend/screens/profile/edit_profile_short_info_screen.dart';
import 'package:canteen_frontend/screens/profile/edit_profile_skill.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/screens/profile/profile_section_title.dart';
import 'package:canteen_frontend/screens/profile/skill_list.dart';
import 'package:canteen_frontend/screens/profile/user_profile_bloc/bloc.dart';
import 'package:canteen_frontend/screens/settings/settings_screen.dart';
import 'package:canteen_frontend/services/firebase_storage.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          padding: EdgeInsets.only(
              bottom: SizeConfig.instance.blockSizeVertical * 9),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.instance.blockSizeVertical * 3),
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
                          size: SizeConfig.instance.blockSizeHorizontal * 50,
                          onTap: () => showPopUpSheet(user),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.instance.blockSizeHorizontal * 3,
                  right: SizeConfig.instance.blockSizeHorizontal * 3,
                  top: SizeConfig.instance.blockSizeVertical,
                  bottom: SizeConfig.instance.blockSizeVertical),
              child: Text('Basic Info'),
            ),
            BasicInfoTab(
                title: 'Name',
                value: user.displayName,
                onTap: () {
                  _userProfileBloc.add(EditName(user));
                }),
            BasicInfoTab(
                title: 'Title',
                value: user.title,
                onTap: () {
                  // _userProfileBloc.add(EditName(user));
                }),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.instance.blockSizeHorizontal * 3),
              child: ProfileSectionTitle('About'),
            ),
            GestureDetector(
              onTap: () {
                _userProfileBloc.add(EditAboutSection(user));
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.instance.blockSizeHorizontal * 3),
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
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.instance.blockSizeHorizontal * 3),
              child: ProfileSectionTitle("I'm teaching"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.instance.blockSizeHorizontal * 3),
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
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.instance.blockSizeHorizontal * 3),
              child: ProfileSectionTitle("I'm learning"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.instance.blockSizeHorizontal * 3),
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
          ],
        ),
      );
    }

    if (state is UserProfileEditingAbout) {
      final user = state.user;
      return EditProfileLongInfoScreen(
        fieldName: 'About',
        initialText: user.about,
        onComplete: (String text) =>
            _userProfileBloc.add(UpdateAboutSection(text)),
        onCancelNavigation: () => _userProfileBloc.add(LoadUserProfile(user)),
        onCompleteNavigation: () => _userProfileBloc.add(LoadUserProfile(user)),
      );
    }

    if (state is UserProfileEditingSkill) {
      return EditProfileSkill(
          user: state.user,
          skillType: state.skillType,
          skillIndex: state.skillIndex);
    }

    if (state is UserProfileEditingName) {
      final user = state.user;
      return EditProfileShortInfoScreen(
        fieldName: 'Name',
        initialText: user.displayName,
        onComplete: (String text) => _userProfileBloc.add(UpdateName(text)),
        onCancelNavigation: () => _userProfileBloc.add(LoadUserProfile(user)),
        onCompleteNavigation: () => _userProfileBloc.add(LoadUserProfile(user)),
        // onCompleteNavigation: () {},
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
