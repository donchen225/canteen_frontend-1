import 'package:badges/badges.dart';
import 'package:canteen_frontend/components/profile_side_bar_button.dart';
import 'package:canteen_frontend/screens/match/match_list_screen.dart';
import 'package:canteen_frontend/screens/request/request_screen.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:flutter/material.dart';

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
        bottom: TabBar(
          indicatorSize: TabBarIndicatorSize.label,
          controller: _tabController,
          labelColor: Palette.primaryColor,
          unselectedLabelColor: Palette.appBarTextColor,
          labelStyle: Theme.of(context).textTheme.headline6,
          tabs: tabChoices.map((text) {
            return _buildBadge(
                0,
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: kTabBarTextPadding,
                  ),
                  child: Tab(
                    text: text,
                  ),
                ));
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[MatchListScreen(), RequestScreen()],
      ),
    );
  }
}
