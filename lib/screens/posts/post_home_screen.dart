import 'package:canteen_frontend/models/like/like.dart';
import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/posts/bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/comment_bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/comment_button.dart';
import 'package:canteen_frontend/screens/posts/enter_post_box.dart';
import 'package:canteen_frontend/screens/posts/group_list_screen.dart';
import 'package:canteen_frontend/screens/posts/like_button.dart';
import 'package:canteen_frontend/screens/posts/post_container.dart';
import 'package:canteen_frontend/screens/posts/post_list_screen.dart';
import 'package:canteen_frontend/screens/posts/post_name_template.dart';
import 'package:canteen_frontend/screens/posts/post_screen_bloc/bloc.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final List<String> tabChoices = [
    'Home',
    'Groups',
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
