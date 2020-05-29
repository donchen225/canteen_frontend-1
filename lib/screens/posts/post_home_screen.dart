import 'package:canteen_frontend/components/profile_side_bar_button.dart';
import 'package:canteen_frontend/screens/posts/group_list_screen.dart';
import 'package:canteen_frontend/screens/posts/post_list_screen.dart';
import 'package:canteen_frontend/screens/search/search_bar.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostHomeScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  _PostHomeScreenState createState() => _PostHomeScreenState();
}

class _PostHomeScreenState extends State<PostHomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool _showFAB = true;
  final List<String> tabChoices = [
    'Posts',
    'Members',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabChoices.length);

    _tabController.addListener(_showFloatingActionButton);
  }

  void _showFloatingActionButton() {
    setState(() {
      _showFAB = _tabController.index == 0;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
              SearchBar(
                height: kToolbarHeight * 0.7,
                width: SizeConfig.instance.safeBlockHorizontal * 100 -
                    kProfileIconSize * 2 -
                    NavigationToolbar.kMiddleSpacing * 4,
                color: Colors.grey[200],
                child: Text(
                  "Search Group",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .apply(color: Palette.textSecondaryBaseColor),
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
              tabs: tabChoices
                  .map(
                    (text) => Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: kTabBarTextPadding,
                      ),
                      child: Tab(
                        text: text,
                      ),
                    ),
                  )
                  .toList()),
        ),
        floatingActionButton: Visibility(
          visible: _showFAB,
          child: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              // showModalBottomSheet(
              //   context: context,
              //   isScrollControlled: true,
              //   backgroundColor: Colors.transparent,
              //   builder: (context) => PostDialogScreen(
              //     user: widget.user,
              //     height: SizeConfig.instance.blockSizeVertical *
              //         kDialogScreenHeightBlocks,
              //   ),
              // );
            },
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            PostListScreen(),
            GroupListScreen(),
          ],
        ));
  }
}
