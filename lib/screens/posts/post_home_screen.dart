import 'package:canteen_frontend/components/app_logo.dart';
import 'package:canteen_frontend/components/profile_side_bar_button.dart';
import 'package:canteen_frontend/models/group/group.dart';
import 'package:canteen_frontend/screens/posts/group_home_member_list_screen.dart';
import 'package:canteen_frontend/screens/posts/post_dialog_screen.dart';
import 'package:canteen_frontend/screens/posts/post_list_screen.dart';
import 'package:canteen_frontend/shared_blocs/group_home/bloc.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostHomeScreen extends StatefulWidget {
  static const routeName = '/';

  PostHomeScreen({Key key}) : super(key: key);

  @override
  _PostHomeScreenState createState() => _PostHomeScreenState();
}

class _PostHomeScreenState extends State<PostHomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool _showFAB = true;
  GroupHomeBloc _groupHomeBloc;

  final List<String> tabs = [
    'Posts',
    'Members',
  ];

  @override
  void initState() {
    super.initState();

    _groupHomeBloc = BlocProvider.of<GroupHomeBloc>(context);
    _tabController = TabController(vsync: this, length: tabs.length);

    _tabController.addListener(_showFloatingActionButton);
    _tabController.addListener(_loadGroupMembers);
  }

  void _showFloatingActionButton() {
    setState(() {
      _showFAB = _tabController.index == 0;
    });
  }

  void _loadGroupMembers() {
    if (_tabController.index == 1) {
      if (!(_groupHomeBloc.currentGroup is DetailedGroup)) {
        _groupHomeBloc
            .add(LoadHomeGroupMembers(_groupHomeBloc.currentGroup.id));
      }
    }
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
            Text('Canteen',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .apply(color: Palette.textColor)),
            Container(
              width: kProfileIconSize,
            )
          ],
        ),
        backgroundColor: Palette.appBarBackgroundColor,
        elevation: 0,
      ),
      floatingActionButton: BlocBuilder<GroupHomeBloc, GroupHomeState>(
        bloc: _groupHomeBloc,
        builder: (BuildContext context, GroupHomeState state) {
          final visible = state is GroupHomeLoaded ? true : false;

          return Visibility(
            visible: _showFAB && visible,
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => PostDialogScreen(
                    groupId: _groupHomeBloc.currentGroup.id,
                    height: SizeConfig.instance.blockSizeVertical *
                        kDialogScreenHeightBlocks,
                  ),
                );
              },
            ),
          );
        },
      ),
      body: BlocBuilder<GroupHomeBloc, GroupHomeState>(
        builder: (BuildContext context, GroupHomeState state) {
          if (state is GroupHomeUninitialized) {
            return Container();
          }

          if (state is GroupHomeLoading) {
            return Center(child: CupertinoActivityIndicator());
          }

          if (state is GroupHomeEmpty) {
            return Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'You are not in any groups.',
                    style: Theme.of(context).textTheme.headline4.apply(
                          fontWeightDelta: 1,
                          color: Palette.textColor,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.instance.safeBlockVertical * 2,
                    ),
                    child: Text(
                      'Join a group in the Discover tab.',
                      style: Theme.of(context).textTheme.headline6.apply(
                            color: Palette.textColor,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is GroupHomeLoaded) {
            final group = state.group;
            final isNotMember = BlocProvider.of<GroupHomeBloc>(context)
                .currentUserGroups
                .where((g) => g.id == group.id)
                .isEmpty;

            return NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
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
                                  child: Row(
                                    children: <Widget>[
                                      // ProfilePicture(
                                      //   photoUrl: userPhotoUrl,
                                      //   shape: BoxShape.circle,
                                      //   editable: false,
                                      //   size: kProfileSize,
                                      // ),
                                      AppLogo(
                                        size: kProfileSize,
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.topLeft,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: SizeConfig.instance
                                                      .safeBlockHorizontal *
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
                                                  group.name,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5
                                                      .apply(
                                                          fontWeightDelta: 2),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: SizeConfig.instance
                                                      .safeBlockVertical,
                                                ),
                                                child: Text(
                                                  group.description ?? '',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                ),
                                              ),
                                              Text(
                                                '${group.members?.toString() ?? "0"} members' ??
                                                    '',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    .apply(
                                                      color: Palette
                                                          .textSecondaryBaseColor,
                                                    ),
                                              ),
                                              Visibility(
                                                visible: isNotMember,
                                                child: FlatButton(
                                                  color: Palette.primaryColor,
                                                  child: Text(
                                                    'JOIN',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .button
                                                        .apply(
                                                            color: Palette
                                                                .whiteColor,
                                                            fontWeightDelta: 1),
                                                  ),
                                                  onPressed: () {},
                                                ),
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
                                    vertical:
                                        SizeConfig.instance.safeBlockVertical,
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
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
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
                  GroupHomeMemberListScreen(),
                ],
              ),
            );
          }
        },
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
