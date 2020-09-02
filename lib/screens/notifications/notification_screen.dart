import 'package:canteen_frontend/components/platform/platform_loading_indicator.dart';
import 'package:canteen_frontend/components/profile_side_bar_button.dart';
import 'package:canteen_frontend/components/small_button.dart';
import 'package:canteen_frontend/components/unauthenticated_functions.dart';
import 'package:canteen_frontend/screens/notifications/bloc/bloc.dart';
import 'package:canteen_frontend/screens/notifications/notification_list.dart';
import 'package:canteen_frontend/screens/posts/text_dialog_screen.dart';
import 'package:canteen_frontend/screens/sign_up/bloc/sign_up_bloc.dart';
import 'package:canteen_frontend/screens/sign_up/sign_up_screen.dart';
import 'package:canteen_frontend/services/navigation_service.dart';
import 'package:canteen_frontend/services/service_locator.dart';
import 'package:canteen_frontend/shared_blocs/user/user_bloc.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotificationScreen extends StatelessWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    final userPhotoUrl =
        CachedSharedPreferences.getString(PreferenceConstants.userPhotoUrl);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(SizeConfig.instance.appBarHeight),
        child: AppBar(
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
      ),
      body: BlocBuilder<NotificationListBloc, NotificationListState>(
        builder: (BuildContext context, NotificationListState state) {
          if (state is NotificationsUnauthenticated) {
            return Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.commentDots,
                    color: Colors.grey,
                    size: 80,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: SizeConfig.instance.safeBlockVertical,
                      bottom: SizeConfig.instance.safeBlockVertical * 2,
                    ),
                    child: Text('Notifications will appear here',
                        style: Theme.of(context).textTheme.bodyText2),
                  ),
                  SmallButton(
                    text: 'Sign Up',
                    onPressed: () =>
                        UnauthenticatedFunctions.showSignUp(context),
                  ),
                ],
              ),
            );
          }

          if (state is NotificationsLoading) {
            return Center(
              child: PlatformLoadingIndicator(),
            );
          }

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
