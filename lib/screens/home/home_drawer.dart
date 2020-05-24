import 'package:canteen_frontend/components/app_logo.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

import 'drawer_item.dart';

class HomeDrawer extends StatefulWidget {
  final UserRepository userRepository;

  HomeDrawer({this.userRepository}) : assert(userRepository != null);

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    final user = widget.userRepository.currentUserNow();
    final titleStyle = Theme.of(context).textTheme.headline6;
    final subtitleStyle = Theme.of(context).textTheme.subtitle2.apply(
          color: Palette.textSecondaryBaseColor,
        );
    final itemHeight = 60.0;

    return Drawer(
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth * 0.05,
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 3,
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
                                      vertical: SizeConfig
                                              .instance.safeBlockVertical *
                                          2,
                                    ),
                                    child: ProfilePicture(
                                      photoUrl: user.photoUrl,
                                      size: constraints.maxWidth * 0.35,
                                    ),
                                  ),
                                  Text(user.displayName,
                                      style:
                                          titleStyle.apply(fontWeightDelta: 1)),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Current Group',
                                  style: subtitleStyle,
                                ),
                                DrawerItem(
                                  leading: AppLogo(
                                    size: 30,
                                  ),
                                  height: itemHeight,
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                    flex: 5,
                    child: ListView(
                      // Important: Remove any padding from the ListView.
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        Text("Groups you're in", style: subtitleStyle),
                        DrawerItem(
                          leading: AppLogo(
                            size: 30,
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
                    leading: Icon(
                      Icons.settings,
                      color: Palette.textSecondaryBaseColor,
                    ),
                    title: Text('Settings',
                        style: Theme.of(context).textTheme.subtitle1),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
