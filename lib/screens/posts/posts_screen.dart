import 'package:canteen_frontend/models/like/like.dart';
import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/screens/posts/bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/comment_bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/comment_button.dart';
import 'package:canteen_frontend/screens/posts/enter_post_box.dart';
import 'package:canteen_frontend/screens/posts/like_button.dart';
import 'package:canteen_frontend/screens/posts/post_container.dart';
import 'package:canteen_frontend/screens/posts/post_name_template.dart';
import 'package:canteen_frontend/screens/posts/single_post_screen.dart';
import 'package:canteen_frontend/screens/search/view_user_profile_screen.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen>
    with SingleTickerProviderStateMixin {
  final Color _sideTextColor = Colors.grey[500];
  TabController _tabController;
  final List<String> tabChoices = [
    'Home',
    'Groups',
    'Notifications',
  ];

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: tabChoices.length);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle bodyTextTheme = Theme.of(context).textTheme.bodyText1;

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
      body: BlocBuilder<PostBloc, PostState>(
        builder: (BuildContext context, PostState state) {
          if (state is PostsLoading) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }

          if (state is PostsLoaded) {
            return CustomScrollView(slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: SizeConfig.instance.safeBlockVertical * 0.5),
                  child: EnterPostBox(
                    user: state.user,
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  final post = state.posts[index];

                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: SizeConfig.instance.safeBlockVertical * 0.5),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) {
                            BlocProvider.of<CommentBloc>(context)
                                .add(LoadComments(postId: post.id));
                            return SinglePostScreen(
                              post: post,
                              user: state.user,
                            );
                          }),
                        );
                      },
                      child: PostContainer(
                          padding: EdgeInsets.only(
                            left: SizeConfig.instance.blockSizeHorizontal * 4,
                            right: SizeConfig.instance.blockSizeHorizontal * 4,
                            top: SizeConfig.instance.blockSizeHorizontal * 3,
                            bottom: SizeConfig.instance.blockSizeHorizontal * 3,
                          ),
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) {
                                        return ViewUserProfileScreen(
                                            user: post.user);
                                      },
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: SizeConfig
                                                .instance.blockSizeVertical *
                                            2),
                                    child: PostNameTemplate(
                                      name: post.user.displayName,
                                      photoUrl: post.user.photoUrl,
                                      time: post.createdOn,
                                      color: _sideTextColor,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    post.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .apply(fontWeightDelta: 1),
                                  ),
                                ),
                                Visibility(
                                  visible: post.message.isNotEmpty,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      post.message,
                                      style: bodyTextTheme,
                                      maxLines: kNumPostOverflowLines,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: SizeConfig
                                              .instance.blockSizeVertical *
                                          2),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          if (!(post.liked)) {
                                            final like = Like(
                                                from: state.user.id,
                                                createdOn: DateTime.now());
                                            BlocProvider.of<PostBloc>(context)
                                                .add(AddLike(post.id, like));
                                          } else {
                                            BlocProvider.of<PostBloc>(context)
                                                .add(DeleteLike(post.id));
                                          }
                                        },
                                        child: LikeButton(
                                            post: post,
                                            sideTextColor: _sideTextColor,
                                            style: bodyTextTheme),
                                      ),
                                      CommentButton(
                                          style: bodyTextTheme,
                                          sideTextColor: _sideTextColor),
                                      Container(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  );
                }, childCount: state.posts.length),
              ),
            ]);
          }

          return Container();
        },
      ),
    );
  }
}
