import 'package:canteen_frontend/screens/home/bloc/bloc.dart';
import 'package:canteen_frontend/screens/match/match_bloc/bloc.dart';
import 'package:canteen_frontend/screens/profile/user_profile_bloc/bloc.dart';
import 'package:canteen_frontend/screens/recommended/bloc/bloc.dart';
import 'package:canteen_frontend/screens/request/request_bloc/bloc.dart';
import 'package:canteen_frontend/shared_blocs/authentication/bloc.dart';
import 'package:canteen_frontend/shared_blocs/settings/bloc.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/push_notifications.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map<String, bool> _settings = {};

  @override
  void initState() {
    super.initState();

    //TODO: load settings from firestore or local cache
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            brightness: Brightness.light,
            title: Text(
              'Settings',
              style: TextStyle(
                color: Palette.appBarTextColor,
              ),
            ),
            backgroundColor: Palette.appBarBackgroundColor,
            leading: BackButton(
              color: Palette.appBarTextColor,
              onPressed: () => BlocProvider.of<UserProfileBloc>(context)
                  .add(ShowUserProfile()),
            ),
            elevation: 1),
        body: ListView(
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.instance.blockSizeVertical * 3),
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: MergeSemantics(
                        child: ListTile(
                          title: Text('Push Notifications'),
                          trailing: CupertinoSwitch(
                            value: _settings['notifications'] ?? false,
                            onChanged: (bool value) {
                              // If false, and notifications are true, turn on
                              // If false, and notifications are false, open ios settings page
                              setState(() {
                                _settings['notifications'] = value;
                              });

                              print('ON CHANGE');
                              print(_settings['notifications']);
                              PushNotificationsManager().registerSettings();
                            },
                          ),
                        ),
                      )),
                    ],
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey[400]),
                color: Colors.white,
              ),
              child: ListTile(
                title: Text('Log out'),
                onTap: () {
                  BlocProvider.of<MatchBloc>(context).add(ClearMatches());
                  BlocProvider.of<RequestBloc>(context).add(ClearRequests());
                  BlocProvider.of<RecommendedBloc>(context)
                      .add(ClearRecommended());
                  BlocProvider.of<HomeBloc>(context).add(ClearHome());
                  BlocProvider.of<SettingBloc>(context).add(ClearSettings());
                  BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                },
              ),
            )
          ],
        ));
  }
}
