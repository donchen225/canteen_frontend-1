import 'package:canteen_frontend/components/user_profile_body.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/shared_blocs/profile_bloc/bloc.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewUserProfileScreen extends StatefulWidget {
  final User user;
  final bool showAppBar;
  final bool canConnect;
  static const routeName = '/user';

  ViewUserProfileScreen(
      {this.user, this.showAppBar = true, this.canConnect = true});

  @override
  _ViewUserProfileScreenState createState() => _ViewUserProfileScreenState();
}

class _ViewUserProfileScreenState extends State<ViewUserProfileScreen> {
  Widget _buildProfileWidget(BuildContext context, User user) {
    return user != null
        ? UserProfileBody(
            user: user,
            canConnect: widget.canConnect,
            headerWidget: widget.showAppBar
                ? null
                : Container(
                    color: Palette.whiteColor,
                    padding: EdgeInsets.only(
                        top: SizeConfig.instance.safeBlockVertical * 3),
                  ),
          )
        : _buildBlocProfile(context);
  }

  Widget _buildBlocProfile(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (BuildContext context, ProfileState state) {
        if (state is ProfileUninitialized) {
          return Container();
        }

        if (state is ProfileLoading) {
          return Center(child: CupertinoActivityIndicator());
        }

        if (state is ProfileLoaded) {
          final user = state.user;
          return UserProfileBody(user: user);
        }

        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.scaffoldBackgroundDarkColor,
      appBar: widget.showAppBar
          ? PreferredSize(
              preferredSize: Size.fromHeight(SizeConfig.instance.appBarHeight),
              child: AppBar(
                backgroundColor: Palette.containerColor,
                elevation: 0,
                leading: BackButton(
                  color: Palette.primaryColor,
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ),
            )
          : null,
      body: _buildProfileWidget(context, widget.user),
    );
  }
}
