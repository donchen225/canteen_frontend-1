import 'package:canteen_frontend/components/profile_side_bar_button.dart';
import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/posts/group_list_screen.dart';
import 'package:canteen_frontend/screens/posts/post_dialog_screen.dart';
import 'package:canteen_frontend/screens/posts/post_list_screen.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostHomeScreen extends StatefulWidget {
  final List<Post> posts;
  final User user;

  PostHomeScreen({this.posts, this.user})
      : assert(posts != null),
        assert(user != null);

  @override
  _PostHomeScreenState createState() => _PostHomeScreenState();
}

class _PostHomeScreenState extends State<PostHomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool _showFAB = true;
  final List<String> tabChoices = [
    'Home',
    'Groups',
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
    return Scaffold(
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
                  user: widget.user,
                  height: SizeConfig.instance.blockSizeVertical *
                      kDialogScreenHeightBlocks,
                ),
              );
            },
          ),
        ),
        appBar: AppBar(
          leading: ProfileSideBarButton(
            userPhotoUrl: widget.user.photoUrl,
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
          brightness: Brightness.light,
          title: Text(
            'Groups',
            style: Theme.of(context).textTheme.headline6.apply(
                  fontFamily: '.SF UI Text',
                  color: Palette.appBarTextColor,
                ),
          ),
          backgroundColor: Palette.appBarBackgroundColor,
          automaticallyImplyLeading: false,
          elevation: 1,
          bottom: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              controller: _tabController,
              tabs: tabChoices
                  .map(
                    (text) => Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: kTabBarTextPadding,
                      ),
                      child: Tab(
                        child: Text(
                          text,
                          style: Theme.of(context).textTheme.headline6.apply(
                                fontFamily: '.SF UI Text',
                                fontSizeFactor: kTabBarTextScaleFactor,
                                color: Palette.appBarTextColor,
                              ),
                        ),
                      ),
                    ),
                  )
                  .toList()),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            PostListScreen(user: widget.user),
            GroupListScreen(),
          ],
        ));
  }
}
