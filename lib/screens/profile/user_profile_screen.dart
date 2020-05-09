import 'package:canteen_frontend/components/interest_item.dart';
import 'package:canteen_frontend/components/profile_upload_sheet.dart';
import 'package:canteen_frontend/models/availability/day.dart';
import 'package:canteen_frontend/models/skill/skill_type.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/profile/add_icon.dart';
import 'package:canteen_frontend/screens/profile/availability_section.dart';
import 'package:canteen_frontend/screens/profile/basic_info_tab.dart';
import 'package:canteen_frontend/screens/profile/edit_availability_screen.dart';
import 'package:canteen_frontend/screens/profile/edit_profile_interests_screen.dart';
import 'package:canteen_frontend/screens/profile/edit_profile_long_info_screen.dart';
import 'package:canteen_frontend/screens/profile/edit_profile_short_info_screen.dart';
import 'package:canteen_frontend/screens/profile/edit_profile_skill.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/screens/profile/profile_section_title.dart';
import 'package:canteen_frontend/screens/profile/profile_text_card.dart';
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
          _userProfileBloc.add(LoadUserProfile(user));
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

  Widget _buildUserInterests(List<String> interests) {
    if (interests.isEmpty) {
      return Row(
        children: <Widget>[
          Text('Add '),
          InterestItem(
            text: 'interests',
          ),
          Text(' and get better matches!'),
        ],
      );
    }

    return Wrap(
        children: interests
            .map((text) => Padding(
                  padding: EdgeInsets.only(
                    right: SizeConfig.instance.blockSizeHorizontal * 3,
                  ),
                  child: InterestItem(
                    text: text,
                  ),
                ))
            .toList());
  }

  Widget _buildUserProfile(UserProfileState state) {
    if (state is UserProfileLoaded) {
      final user = state.user;

      return Scaffold(
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
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.instance.blockSizeHorizontal * 3),
              child: ProfileSectionTitle('Basic Info'),
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
                  _userProfileBloc.add(EditTitle(user));
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
                  child: ProfileTextCard(
                    child: Text(user.about ?? ''),
                  )),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.instance.blockSizeHorizontal * 3),
              child: ProfileSectionTitle("Interests"),
            ),
            GestureDetector(
              onTap: () {
                _userProfileBloc.add(EditInterests(user));
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.instance.blockSizeHorizontal * 3),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ProfileTextCard(
                        child: _buildUserInterests(user.interests),
                      ),
                    ),
                  ],
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
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.instance.blockSizeHorizontal * 3),
              child: ProfileSectionTitle("Availability"),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: SizeConfig.instance.blockSizeHorizontal * 3,
                right: SizeConfig.instance.blockSizeHorizontal * 3,
                bottom: SizeConfig.instance.blockSizeVertical,
              ),
              child: Text(
                'Time Zone',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.instance.blockSizeHorizontal * 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Users see their local time',
                  ),
                  Text(
                    'Your time zone is ${state.settings.timeZoneName}',
                    style: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.grey[600]),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.instance.blockSizeHorizontal * 3,
                  vertical: SizeConfig.instance.blockSizeVertical),
              child: Text(
                'Recurring Availability',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.instance.blockSizeHorizontal * 3,
              ),
              child: AvailabilitySection(
                availability: user.availability,
                onDayTap: (Day day, TimeOfDay startTime, TimeOfDay endTime) =>
                    _userProfileBloc.add(EditAvailability(
                        user: user,
                        day: day,
                        startTime: startTime,
                        endTime: endTime)),
              ),
            ),
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
      );
    }

    if (state is UserProfileEditingTitle) {
      final user = state.user;
      return EditProfileShortInfoScreen(
        fieldName: 'Title',
        initialText: user.title,
        onComplete: (String text) => _userProfileBloc.add(UpdateTitle(text)),
        onCancelNavigation: () => _userProfileBloc.add(LoadUserProfile(user)),
        onCompleteNavigation: () => _userProfileBloc.add(LoadUserProfile(user)),
      );
    }

    if (state is UserProfileEditingInterests) {
      final user = state.user;
      return EditProfileInterestsScreen(
        fieldName: 'Interests',
        initialItems: user.interests ?? [],
        onComplete: (List<String> interests) =>
            _userProfileBloc.add(UpdateInterests(interests)),
        onCancelNavigation: () => _userProfileBloc.add(LoadUserProfile(user)),
        onCompleteNavigation: () => _userProfileBloc.add(LoadUserProfile(user)),
      );
    }

    if (state is UserProfileEditingAvailability) {
      final user = state.user;
      return EditAvailabilityScreen(
        fieldName: 'Availability',
        startTime: state.startTime,
        endTime: state.endTime,
        day: state.day,
        onComplete: (Day day, int startTime, int endTime) =>
            _userProfileBloc.add(UpdateAvailability(day, startTime, endTime)),
        onCancelNavigation: () => _userProfileBloc.add(LoadUserProfile(user)),
        onCompleteNavigation: () => _userProfileBloc.add(LoadUserProfile(user)),
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
