import 'package:canteen_frontend/components/profile_side_bar_button.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    final userPhotoUrl =
        CachedSharedPreferences.getString(PreferenceConstants.userPhotoUrl);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ProfileSideBarButton(
              userPhotoUrl: userPhotoUrl,
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            Text(
              'Notifications',
              style: Theme.of(context).textTheme.headline6.apply(
                    color: Palette.appBarTextColor,
                  ),
            ),
            Container(
              width: kProfileIconSize,
            )
          ],
        ),
        backgroundColor: Palette.appBarBackgroundColor,
        elevation: 1,
      ),
    );
  }
}
