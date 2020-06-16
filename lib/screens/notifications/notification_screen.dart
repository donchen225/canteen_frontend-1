import 'package:canteen_frontend/components/profile_side_bar_button.dart';
import 'package:canteen_frontend/screens/notifications/bloc/bloc.dart';
import 'package:canteen_frontend/screens/notifications/notification_list.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                    fontWeightDelta: 2,
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
      body: BlocBuilder<NotificationListBloc, NotificationListState>(
        builder: (BuildContext context, NotificationListState state) {
          print('STATE: $state');
          if (state is NotificationsLoaded) {
            final notifications = state.notifications;

            return NotificationList(notifications: notifications);
          }

          return Container();
        },
      ),
    );
  }
}
