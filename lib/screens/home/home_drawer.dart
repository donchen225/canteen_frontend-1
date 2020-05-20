import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

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

    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: DrawerHeader(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Container(
                    width: constraints.maxWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.instance.safeBlockVertical * 3,
                          ),
                          child: ProfilePicture(
                            photoUrl: user.photoUrl,
                            size: constraints.maxWidth * 0.35,
                          ),
                        ),
                        Text(user.displayName, style: titleStyle),
                      ],
                    ),
                  );
                },
              ),
              decoration: BoxDecoration(),
            ),
          ),
          Expanded(
            flex: 4,
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  title: Text('Item 1'),
                  onTap: () {
                    // Update the state of the app.
                    // ...
                  },
                ),
                ListTile(
                  title: Text('Item 2'),
                  onTap: () {
                    // Update the state of the app.
                    // ...
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
