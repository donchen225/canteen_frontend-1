import 'dart:async';

import 'package:canteen_frontend/components/custom_tile.dart';
import 'package:canteen_frontend/components/unauthenticated_functions.dart';
import 'package:canteen_frontend/screens/home/bloc/bloc.dart';
import 'package:canteen_frontend/screens/home/navigation_bar_badge_bloc/bloc.dart';
import 'package:canteen_frontend/screens/match/match_bloc/bloc.dart';
import 'package:canteen_frontend/screens/notifications/bloc/bloc.dart';
import 'package:canteen_frontend/screens/request/request_bloc/bloc.dart';
import 'package:canteen_frontend/shared_blocs/authentication/bloc.dart';
import 'package:canteen_frontend/shared_blocs/group_home/bloc.dart';
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
  bool _authenticated;
  Map<String, dynamic> _settings = {};

  @override
  void initState() {
    super.initState();
    print('INIT SETTINGS SCREEN');

    _authenticated =
        BlocProvider.of<AuthenticationBloc>(context).state is Authenticated;
    if (_authenticated) {
      _settings['push_notifications_app'] = CachedSharedPreferences.getBool(
          PreferenceConstants.pushNotificationsApp);
      PushNotificationsManager().getSettings();
      _settings['push_notifications_system'] = jsonDecode(
          CachedSharedPreferences.getString(
              PreferenceConstants.pushNotificationsSystem));
    } else {
      _settings['push_notifications_app'] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingBloc, SettingState>(
      listener: (BuildContext context, SettingState state) {
        if (state is SettingsUninitialized) {
          Navigator.of(context, rootNavigator: true).maybePop();
          BlocProvider.of<HomeBloc>(context).add(ClearHome());
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
        }
      },
      child: BlocBuilder<SettingBloc, SettingState>(
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
                                        value:
                                            _settings['push_notifications_app'],
                                        onChanged: (bool value) {
                                          // If false, and notifications are true, turn on
                                          // TODO: If false, and notifications are false, open ios settings page
                                          setState(() {
                                            _settings[
                                                    'push_notifications_app'] =
                                                value;
                                            if (_authenticated) {
                                              BlocProvider.of<SettingBloc>(
                                                      context)
                                                  .add(
                                                      ToggleAppPushNotifications(
                                                          notifications:
                                                              value));
                                            }
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: !_settings['push_notifications_app'],
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.only(
                                      left: 16,
                                      right: 80,
                                    ),
                                    child: Text(
                                      'By having this set to off, you may miss a connection. You must turn on notifications from your device system settings first.',
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
                  child: CustomTile(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                          _authenticated ? 'Log out' : 'Sign up / Log in',
                          style: Theme.of(context).textTheme.bodyText1),
                    ),
                    onTap: () {
                      if (_authenticated) {
                        BlocProvider.of<SettingBloc>(context)
                            .add(ClearSettings());
                        BlocProvider.of<HomeNavigationBarBadgeBloc>(context)
                            .add(ClearBadgeCounts());
                        BlocProvider.of<MatchBloc>(context).add(ClearMatches());
                        BlocProvider.of<RequestBloc>(context)
                            .add(ClearRequests());
                        BlocProvider.of<GroupHomeBloc>(context)
                            .add(ClearHomeGroup());
                        BlocProvider.of<NotificationListBloc>(context)
                            .add(ClearNotifications());
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Dialog(
                              backgroundColor: Colors.transparent,
                              child: Center(
                                child: CupertinoActivityIndicator(),
                              ),
                            );
                          },
                        ).then((value) => Timer(
                            const Duration(seconds: 1),
                            () => Navigator.of(context)
                                .pop())); // TODO: change this to wait for BLoCs);
                      } else {
                        UnauthenticatedFunctions.showSignUp(context);
                      }
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
