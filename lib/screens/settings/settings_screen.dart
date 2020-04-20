import 'package:canteen_frontend/screens/match/match_bloc/bloc.dart';
import 'package:canteen_frontend/screens/profile/user_profile_bloc/bloc.dart';
import 'package:canteen_frontend/screens/request/request_bloc/bloc.dart';
import 'package:canteen_frontend/shared_blocs/authentication/bloc.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
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
              vertical: SizeConfig.instance.blockSizeVertical * 6),
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey[400]),
                color: Colors.white,
              ),
              child: ListTile(
                title: Text('Log out'),
                onTap: () {
                  BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                  BlocProvider.of<MatchBloc>(context).add(ClearMatches());
                  BlocProvider.of<RequestBloc>(context).add(ClearRequests());
                },
              ),
            )
          ],
        ));
  }
}
