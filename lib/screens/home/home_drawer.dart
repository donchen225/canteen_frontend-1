import 'package:canteen_frontend/components/app_logo.dart';
import 'package:canteen_frontend/components/group_picture.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
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

  @override
  Widget build(BuildContext context) {
    final userPhotoUrl =
        CachedSharedPreferences.getString(PreferenceConstants.userPhotoUrl);
    final userName =
        CachedSharedPreferences.getString(PreferenceConstants.userName);
    final titleStyle = Theme.of(context).textTheme.headline6;
    final subtitleStyle = Theme.of(context).textTheme.subtitle1.apply(
          color: Palette.textSecondaryBaseColor,
        );

    final currentGroup = _groupHomeBloc.currentGroup;
    final userGroups = _groupHomeBloc.currentGroups;

    return Drawer(
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Column(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Container(
                    width: constraints.maxWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical:
                                        SizeConfig.instance.safeBlockVertical *
                                            2,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).maybePop();
                                      if (widget.onUserTap != null) {
                                        widget.onUserTap();
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
                                    Navigator.of(context).maybePop();
                                    if (widget.onUserTap != null) {
                                      widget.onUserTap();
                                    }
                                  },
                                  child: Text(userName,
                                      style:
                                          titleStyle.apply(fontWeightDelta: 1)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(
                              bottom: SizeConfig.instance.safeBlockVertical),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // Padding(
                              //   padding: EdgeInsets.only(
                              //     left: constraints.maxWidth * 0.05,
                              //     right: constraints.maxWidth * 0.05,
                              //     top: 10,
                              //     bottom: 10,
                              //   ),
                              //   child: Row(
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.spaceBetween,
                              //     children: <Widget>[
                              //       Text(
                              //         '\$ 10.00 in Canteen',
                              //         style:
                              //             Theme.of(context).textTheme.bodyText1,
                              //       ),
                              //       FlatButton(
                              //         color: Palette.primaryColor,
                              //         child: Text(
                              //           'Transfer',
                              //           style: Theme.of(context)
                              //               .textTheme
                              //               .button
                              //               .apply(
                              //                   fontWeightDelta: 1,
                              //                   color: Palette.whiteColor),
                              //         ),
                              //         onPressed: () {},
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: constraints.maxWidth * 0.05,
                                ),
                                child: Text(
                                  'Current Group',
                                  style: subtitleStyle,
                                ),
                              ),
                              Visibility(
                                visible: currentGroup != null,
                                child: DrawerItem(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        currentGroup?.name ?? '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .apply(
                                              fontWeightDelta: 2,
                                            ),
                                      ),
                                      Text(
                                          '${currentGroup?.members?.toString() ?? 0} members'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .apply(
                                          fontWeightDelta: 2,
                                        ),
                                  ),
                                  Text('${group.members.toString()} members'),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
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
