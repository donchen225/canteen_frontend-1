import 'package:canteen_frontend/components/profile_side_bar_button.dart';
import 'package:canteen_frontend/screens/posts/group_list_screen.dart';
import 'package:canteen_frontend/screens/posts/post_dialog_screen.dart';
import 'package:canteen_frontend/screens/posts/post_list_screen.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
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

  final List<String> tabs = [
    'Posts',
    'Members',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);

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
        elevation: 0,
      ),
      floatingActionButton: Visibility(
        visible: _showFAB,
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => PostDialogScreen(
                height: SizeConfig.instance.blockSizeVertical *
                    kDialogScreenHeightBlocks,
              ),
            );
          },
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Container(
                color: Palette.containerColor,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        top: SizeConfig.instance.safeBlockVertical * 2,
                        left: SizeConfig.instance.safeBlockHorizontal *
                            kHorizontalPaddingBlocks,
                        right: SizeConfig.instance.safeBlockHorizontal *
                            kHorizontalPaddingBlocks,
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: kProfileSize,
                            child: Row(
                              children: <Widget>[
                                ProfilePicture(
                                  photoUrl: userPhotoUrl,
                                  shape: BoxShape.circle,
                                  editable: false,
                                  size: kProfileSize,
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: SizeConfig
                                                .instance.safeBlockHorizontal *
                                            kHorizontalPaddingBlocks),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                            bottom: SizeConfig.instance
                                                    .safeBlockVertical *
                                                0.5,
                                          ),
                                          child: Text(
                                            'Modernist',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5
                                                .apply(fontWeightDelta: 2),
                                          ),
                                        ),
                                        Text(
                                          'Group description' ?? '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                        Text(
                                          '600 members' ?? '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.instance.safeBlockVertical,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(
                      indicatorSize: TabBarIndicatorSize.label,
                      controller: _tabController,
                      labelColor: Palette.primaryColor,
                      unselectedLabelColor: Palette.appBarTextColor,
                      labelStyle: Theme.of(context).textTheme.headline6,
                      tabs: tabs
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
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            PostListScreen(),
            GroupListScreen(),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 0.5,
            color: Colors.grey[400],
          ),
        ),
      ),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
