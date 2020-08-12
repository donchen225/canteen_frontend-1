import 'package:badges/badges.dart';
import 'package:canteen_frontend/components/profile_side_bar_button.dart';
import 'package:canteen_frontend/screens/home/navigation_bar_badge_bloc/bloc.dart';
import 'package:canteen_frontend/screens/match/match_list_screen.dart';
import 'package:canteen_frontend/screens/request/request_screen.dart';
import 'package:canteen_frontend/services/home_navigation_bar_service.dart';
import 'package:canteen_frontend/services/service_locator.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageScreen extends StatefulWidget {
  static const routeName = '/';

  MessageScreen({Key key}) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  final List<String> tabChoices = ['Chats', 'Requests'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabChoices.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildBadge(int count, Widget child) {
    if (count == 0) {
      return child;
    }

    return Badge(
      badgeColor: Palette.badgeColor,
      toAnimate: false,
      badgeContent: Text(
        count.toString(),
        style: count < 10
            ? TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              )
            : TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 9,
              ),
      ),
      position: BadgePosition.topRight(top: 1, right: -3),
      showBadge: count != 0,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userPhotoUrl =
        CachedSharedPreferences.getString(PreferenceConstants.userPhotoUrl);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kAppBarHeight + kTabBarHeight),
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
                'Messages',
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
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kTabBarHeight),
            child: BlocBuilder<HomeNavigationBarBadgeBloc,
                HomeNavigationBarBadgeState>(
              builder:
                  (BuildContext context, HomeNavigationBarBadgeState state) {
                return Container(
                  height: kTabBarHeight,
                  child: TabBar(
                    key: getIt<NavigationBarService>().messageTabBarKey,
                    indicatorSize: TabBarIndicatorSize.label,
                    controller: _tabController,
                    labelColor: Palette.primaryColor,
                    unselectedLabelColor: Palette.appBarTextColor,
                    labelStyle: Theme.of(context).textTheme.headline6,
                    tabs: <Widget>[
                      _buildBadge(
                        state.numMessages,
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: kTabBarTextPadding,
                          ),
                          child: Tab(
                            text: tabChoices[0],
                          ),
                        ),
                      ),
                      _buildBadge(
                        state.numRequests,
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: kTabBarTextPadding,
                          ),
                          child: Tab(
                            text: tabChoices[1],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[MatchListScreen(), RequestScreen()],
      ),
    );
  }
}
