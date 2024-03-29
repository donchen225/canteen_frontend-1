import 'package:canteen_frontend/components/confirm_button.dart';
import 'package:canteen_frontend/components/dialog_screen.dart';
import 'package:canteen_frontend/components/interest_item.dart';
import 'package:canteen_frontend/components/platform/platform_loading_indicator.dart';
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
import 'package:canteen_frontend/screens/profile/profile_section.dart';
import 'package:canteen_frontend/screens/profile/profile_section_title.dart';
import 'package:canteen_frontend/screens/profile/profile_text_card.dart';
import 'package:canteen_frontend/screens/profile/skill_list.dart';
import 'package:canteen_frontend/screens/profile/user_profile_bloc/bloc.dart';
import 'package:canteen_frontend/screens/settings/settings_screen.dart';
import 'package:canteen_frontend/services/firebase_storage.dart';
import 'package:canteen_frontend/utils/constants.dart';
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
  final horizontalPaddingBlocks = 4;
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

      return DialogScreen(
        title: 'Edit Profile',
        sendWidget: ConfirmButton(
          onTap: (_) {
            Navigator.of(context).maybePop();
          },
        ),
        child: ListView(
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
            ProfileSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.instance.safeBlockHorizontal *
                            horizontalPaddingBlocks),
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
                ],
              ),
            ),
            ProfileSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.instance.safeBlockHorizontal *
                            horizontalPaddingBlocks),
                    child: ProfileSectionTitle('About'),
                  ),
                  GestureDetector(
                    onTap: () {
                      _userProfileBloc.add(EditAboutSection(user));
                    },
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                SizeConfig.instance.safeBlockHorizontal *
                                    horizontalPaddingBlocks),
                        child: ProfileTextCard(
                          child: Text(user.about ?? ''),
                        )),
                  ),
                ],
              ),
            ),
            ProfileSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.instance.safeBlockHorizontal *
                            horizontalPaddingBlocks),
                    child: ProfileSectionTitle("Interests"),
                  ),
                  GestureDetector(
                    onTap: () {
                      _userProfileBloc.add(EditInterests(user));
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.instance.safeBlockHorizontal *
                              horizontalPaddingBlocks),
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
                ],
              ),
            ),
            ProfileSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.instance.safeBlockHorizontal *
                            horizontalPaddingBlocks),
                    child: ProfileSectionTitle("Offerings"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.instance.safeBlockHorizontal *
                                horizontalPaddingBlocks -
                            6),
                    child: SkillList(
                      user.teachSkill,
                      onTap: (int index) => _userProfileBloc
                          .add(EditSkill(user, SkillType.offer, index)),
                    ),
                  ),
                  user.teachSkill.length < 3
                      ? Align(
                          alignment: Alignment.center,
                          child: AddIcon(
                            160,
                            onTap: () {
                              _userProfileBloc.add(EditSkill(user,
                                  SkillType.offer, user.teachSkill.length));
                            },
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            ProfileSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.instance.safeBlockHorizontal *
                            horizontalPaddingBlocks),
                    child: ProfileSectionTitle("Asks"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.instance.safeBlockHorizontal *
                            horizontalPaddingBlocks),
                    child: SkillList(
                      user.learnSkill,
                      onTap: (int index) => _userProfileBloc
                          .add(EditSkill(user, SkillType.request, index)),
                    ),
                  ),
                  user.learnSkill.length < 3
                      ? Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: AddIcon(
                              160,
                              onTap: () {
                                _userProfileBloc.add(EditSkill(user,
                                    SkillType.request, user.learnSkill.length));
                              },
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.instance.safeBlockHorizontal *
                      horizontalPaddingBlocks),
              child: ProfileSectionTitle("Availability"),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: SizeConfig.instance.safeBlockHorizontal *
                    horizontalPaddingBlocks,
                right: SizeConfig.instance.safeBlockHorizontal *
                    horizontalPaddingBlocks,
                bottom: SizeConfig.instance.blockSizeVertical,
              ),
              child: Text(
                'Time Zone',
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    .apply(fontWeightDelta: 1),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.instance.safeBlockHorizontal *
                      horizontalPaddingBlocks),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Your time zone is ${state.settings.timeZoneName}',
                    style: Theme.of(context).textTheme.bodyText2.apply(
                        fontStyle: FontStyle.italic, color: Colors.grey[600]),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.instance.safeBlockHorizontal *
                      horizontalPaddingBlocks,
                  vertical: SizeConfig.instance.blockSizeVertical),
              child: Text(
                'Recurring Availability',
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    .apply(fontWeightDelta: 1),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.instance.safeBlockHorizontal *
                    horizontalPaddingBlocks,
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
        return Center(child: PlatformLoadingIndicator());
      } else {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: animationDuration),
          switchOutCurve: Threshold(0),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(offsetdXForward, 0),
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
