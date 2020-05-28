import 'package:canteen_frontend/components/profile_side_bar_button.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userPhotoUrl =
        CachedSharedPreferences.getString(PreferenceConstants.userPhotoUrl);

    return Scaffold(
      appBar: AppBar(
        leading: ProfileSideBarButton(
          userPhotoUrl: userPhotoUrl,
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        brightness: Brightness.light,
        title: Text(
          'Notifications',
          style: Theme.of(context).textTheme.headline6.apply(
                fontFamily: '.SF UI Text',
                color: Palette.appBarTextColor,
              ),
        ),
        backgroundColor: Palette.appBarBackgroundColor,
        automaticallyImplyLeading: false,
        elevation: 1,
      ),
    );
  }
}
