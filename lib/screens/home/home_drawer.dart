import 'package:canteen_frontend/components/app_logo.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

import 'drawer_item.dart';

class HomeDrawer extends StatefulWidget {
  final Function onUserTap;
  final Function onSettingsTap;

  HomeDrawer({this.onUserTap, this.onSettingsTap});

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    final userPhotoUrl =
        CachedSharedPreferences.getString(PreferenceConstants.userPhotoUrl);
    final userName =
        CachedSharedPreferences.getString(PreferenceConstants.userName);
    final titleStyle = Theme.of(context).textTheme.headline6;
    final subtitleStyle = Theme.of(context).textTheme.subtitle2.apply(
          color: Palette.textSecondaryBaseColor,
        );
    final itemHeight = 60.0;

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
                              DrawerItem(
                                leading: AppLogo(
                                  size: 30,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: constraints.maxWidth * 0.05,
                                ),
                                height: itemHeight,
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Cognitive World',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .apply(
                                            fontWeightDelta: 2,
                                          ),
                                    ),
                                    Text('620 members'),
                                  ],
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
                  child: ListView(
                    // Important: Remove any padding from the ListView.
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth * 0.05,
                        ),
                        child: Text("Groups you're in", style: subtitleStyle),
                      ),
                      DrawerItem(
                        leading: AppLogo(
                          size: 30,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth * 0.05,
                        ),
                        height: itemHeight,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Superconnectors',
                              style:
                                  Theme.of(context).textTheme.subtitle1.apply(
                                        fontWeightDelta: 2,
                                      ),
                            ),
                            Text('100 members'),
                          ],
                        ),
                      ),
                      DrawerItem(
                        leading: AppLogo(
                          size: 30,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth * 0.05,
                        ),
                        height: itemHeight,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Modernist',
                              style:
                                  Theme.of(context).textTheme.subtitle1.apply(
                                        fontWeightDelta: 2,
                                      ),
                            ),
                            Text('80 members'),
                          ],
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
