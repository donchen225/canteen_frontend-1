import 'package:canteen_frontend/screens/home/bloc/bloc.dart';
import 'package:canteen_frontend/screens/home/navigation_bar_badge_bloc/bloc.dart';
import 'package:canteen_frontend/screens/match/match_bloc/bloc.dart';
import 'package:canteen_frontend/screens/request/request_bloc/bloc.dart';
import 'package:canteen_frontend/shared_blocs/authentication/bloc.dart';
import 'package:canteen_frontend/shared_blocs/settings/bloc.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/push_notifications.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:convert';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map<String, dynamic> _settings = {};

  @override
  void initState() {
    super.initState();
    print('INIT SETTINGS SCREEN');
    _settings['push_notification_app'] = CachedSharedPreferences.getBool(
        PreferenceConstants.pushNotificationsApp);
    _settings['push_notification_system'] = jsonDecode(
        CachedSharedPreferences.getString(
            PreferenceConstants.pushNotificationsSystem));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (BuildContext context, SettingState state) {
        return Scaffold(
          backgroundColor: Palette.scaffoldBackgroundLightColor,
          appBar: AppBar(
              title: Text(
                'Settings',
                style: TextStyle(
                  color: Palette.appBarTextColor,
                ),
              ),
              backgroundColor: Palette.appBarBackgroundColor,
              leading: BackButton(
                color: Palette.appBarTextColor,
                onPressed: () => Navigator.of(context).maybePop(),
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
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('Push Notifications',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                    CupertinoSwitch(
                                      value: _settings['push_notification_app'],
                                      onChanged: (bool value) {
                                        // If false, and notifications are true, turn on
                                        // If false, and notifications are false, open ios settings page
                                        setState(() {
                                          _settings['push_notification_app'] =
                                              value;
                                          BlocProvider.of<SettingBloc>(context)
                                              .add(ToggleAppPushNotifications(
                                                  notifications: value));
                                        });
                                      },
                                    )
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: !_settings['push_notification_app'],
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.only(
                                    left: 16,
                                    right: 80,
                                  ),
                                  child: Text(
                                    'By having this set to off, you may miss a connection.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .apply(color: Colors.red[400]),
                                  ),
                                ),
                              ),
                            ],
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
                margin: EdgeInsets.only(
                  top: 15,
                  bottom: 15,
                ),
                child: ListTile(
                  title: Text('Log out'),
                  onTap: () {
                    BlocProvider.of<HomeNavigationBarBadgeBloc>(context)
                        .add(ClearBadgeCounts());
                    BlocProvider.of<HomeBloc>(context).add(ClearHome());
                    BlocProvider.of<MatchBloc>(context).add(ClearMatches());
                    BlocProvider.of<RequestBloc>(context).add(ClearRequests());
                    BlocProvider.of<SettingBloc>(context).add(ClearSettings());
                    BlocProvider.of<AuthenticationBloc>(context)
                        .add(LoggedOut());
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
