import 'package:canteen_frontend/components/group_picture.dart';
import 'package:canteen_frontend/components/unauthenticated_functions.dart';
import 'package:canteen_frontend/models/group/group.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/shared_blocs/authentication/bloc.dart';
import 'package:canteen_frontend/shared_blocs/group_home/bloc.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'drawer_item.dart';

class HomeDrawer extends StatefulWidget {
  final Function onUserTap;
  final Function onSettingsTap;

  HomeDrawer({this.onUserTap, this.onSettingsTap});

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  final double itemHeight = 60.0;
  GroupHomeBloc _groupHomeBloc;

  @override
  void initState() {
    super.initState();

    _groupHomeBloc = BlocProvider.of<GroupHomeBloc>(context);
  }

  Widget _buildDrawerBody(
      {bool authenticated,
      BoxConstraints constraints,
      TextStyle subtitleStyle,
      Group currentGroup,
      BuildContext context,
      List<Group> userGroups}) {
    if (!authenticated) {
      return Column(
        children: [
          DrawerItem(
            height: itemHeight,
            padding: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth * 0.05,
            ),
            leading: Icon(
              Icons.account_circle,
              color: Palette.textSecondaryBaseColor,
            ),
            onTap: () {
              Navigator.of(context)
                  .maybePop()
                  .then((_) => UnauthenticatedFunctions.showSignUp(context));
            },
            title: Text('Sign up / Log in',
                style: Theme.of(context).textTheme.subtitle1),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: SizeConfig.instance.safeBlockVertical),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DrawerItem(
                height: itemHeight,
                padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth * 0.05,
                ),
                leading: Icon(
                  Icons.account_circle,
                  color: Palette.textSecondaryBaseColor,
                ),
                onTap: () {
                  if (authenticated) {
                    Navigator.of(context).maybePop();
                    if (widget.onUserTap != null) {
                      widget.onUserTap();
                    }
                  }
                },
                title: Text('Profile',
                    style: Theme.of(context).textTheme.subtitle1),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth * 0.05,
                ),
                child: Text(
                  'Current Group',
                  style: subtitleStyle,
                ),
              ),
              currentGroup != null
                  ? DrawerItem(
                      leading: GroupPicture(
                        photoUrl: currentGroup.photoUrl,
                        shape: BoxShape.circle,
                        size: 30,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: constraints.maxWidth * 0.05,
                      ),
                      height: itemHeight,
                      onTap: () {
                        Navigator.of(context).maybePop();
                      },
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            currentGroup?.name ?? '',
                            style: Theme.of(context).textTheme.subtitle1.apply(
                                  fontWeightDelta: 2,
                                ),
                          ),
                          Visibility(
                            visible: currentGroup != null,
                            child: Text(
                              '${currentGroup?.type == 'public' ? 'Public' : 'Private' ?? 'Public'} group',
                              style:
                                  Theme.of(context).textTheme.bodyText2.apply(
                                        color: Palette.textSecondaryBaseColor,
                                      ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: constraints.maxWidth * 0.05,
          ),
          child: Text("Groups you're in", style: subtitleStyle),
        ),
        Expanded(
          child: ListView.builder(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            itemCount: userGroups.length,
            itemBuilder: (BuildContext context, int index) {
              final group = userGroups[index];
              return DrawerItem(
                leading: GroupPicture(
                  photoUrl: group.photoUrl,
                  shape: BoxShape.circle,
                  size: 30,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth * 0.05,
                ),
                height: itemHeight,
                onTap: () {
                  BlocProvider.of<GroupHomeBloc>(context)
                      .add(LoadHomeGroup(group));
                  Navigator.of(context).maybePop();
                },
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      group.name,
                      style: Theme.of(context).textTheme.subtitle1.apply(
                            fontWeightDelta: 2,
                          ),
                    ),
                    Visibility(
                      visible: currentGroup != null,
                      child: Text(
                        '${currentGroup?.type == 'public' ? 'Public' : 'Private' ?? 'Public'} group',
                        style: Theme.of(context).textTheme.bodyText2.apply(
                              color: Palette.textSecondaryBaseColor,
                            ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final userPhotoUrl =
        CachedSharedPreferences.getString(PreferenceConstants.userPhotoUrl);
    final userName =
        CachedSharedPreferences.getString(PreferenceConstants.userName);
    final titleStyle = Theme.of(context).textTheme.headline6;
    final subtitleStyle = Theme.of(context).textTheme.bodyText2.apply(
          color: Palette.textSecondaryBaseColor,
        );

    final currentGroup = _groupHomeBloc.currentGroup;
    final userGroups = _groupHomeBloc.currentGroups;

    final authenticated =
        BlocProvider.of<AuthenticationBloc>(context).state is Authenticated;

    return Drawer(
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Column(
              children: <Widget>[
                Container(
                  width: constraints.maxWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical:
                                    SizeConfig.instance.safeBlockVertical * 2,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  if (authenticated) {
                                    Navigator.of(context).maybePop();
                                    if (widget.onUserTap != null) {
                                      widget.onUserTap();
                                    }
                                  }
                                },
                                child: ProfilePicture(
                                  photoUrl: userPhotoUrl,
                                  size: constraints.maxWidth * 0.35,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                final authenticated =
                                    BlocProvider.of<AuthenticationBloc>(context)
                                        .state is Authenticated;

                                if (authenticated) {
                                  Navigator.of(context).maybePop();
                                  if (widget.onUserTap != null) {
                                    widget.onUserTap();
                                  }
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: constraints.maxWidth * 0.05),
                                child: Text(
                                    authenticated
                                        ? userName
                                        : "Sign up to connect with others, customize your feed, share your interests, and more!",
                                    textAlign: TextAlign.center,
                                    style: authenticated
                                        ? titleStyle.apply(fontWeightDelta: 1)
                                        : subtitleStyle.apply(
                                            color: Palette.textColor)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _buildDrawerBody(
                      authenticated: authenticated,
                      constraints: constraints,
                      subtitleStyle: subtitleStyle,
                      currentGroup: currentGroup,
                      context: context,
                      userGroups: userGroups),
                ),
                DrawerItem(
                  height: itemHeight,
                  padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth * 0.05,
                  ),
                  leading: Icon(
                    Icons.settings,
                    color: Palette.textSecondaryBaseColor,
                  ),
                  onTap: () {
                    Navigator.of(context).maybePop();
                    if (widget.onSettingsTap != null) {
                      widget.onSettingsTap();
                    }
                  },
                  title: Text('Settings',
                      style: Theme.of(context).textTheme.subtitle1),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
