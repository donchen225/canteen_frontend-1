import 'package:canteen_frontend/screens/posts/bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/enter_post_box.dart';
import 'package:canteen_frontend/screens/posts/post_container.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostScreen extends StatelessWidget {
  final Color _sideTextColor = Colors.grey[500];

  String formatTime(DateTime time) {
    String t = timeago
        .format(time, locale: 'en_short')
        .replaceFirst(' ', '')
        .replaceFirst('~', '')
        .replaceFirst('min', 'm');

    return t;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        title: Text(
          'Home',
          style: TextStyle(
            color: Color(0xFF303030),
          ),
        ),
        backgroundColor: Palette.appBarBackgroundColor,
        elevation: 1,
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
                      bottom: SizeConfig.instance.blockSizeVertical),
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
                        bottom: SizeConfig.instance.blockSizeVertical),
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
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom:
                                        SizeConfig.instance.blockSizeVertical *
                                            2),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                        right: SizeConfig
                                                .instance.blockSizeHorizontal *
                                            2,
                                      ),
                                      child: ProfilePicture(
                                        photoUrl: post.user.photoUrl,
                                        editable: false,
                                        size: SizeConfig
                                                .instance.blockSizeHorizontal *
                                            6,
                                      ),
                                    ),
                                    Text(
                                      post.user.displayName ?? '',
                                      style: TextStyle(color: _sideTextColor),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: SizeConfig
                                              .instance.blockSizeHorizontal),
                                      child: Container(
                                        width: SizeConfig
                                            .instance.blockSizeHorizontal,
                                        height: SizeConfig
                                            .instance.blockSizeHorizontal,
                                        decoration: BoxDecoration(
                                          color: _sideTextColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      formatTime(post.createdOn),
                                      style: TextStyle(
                                          color: _sideTextColor, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  post.title,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: SizeConfig
                                              .instance.blockSizeVertical *
                                          2 *
                                          1.2),
                                ),
                              ),
                              Visibility(
                                visible: post.message.isNotEmpty,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    post.message,
                                    style: TextStyle(
                                        fontSize: SizeConfig
                                                .instance.blockSizeVertical *
                                            1.5 *
                                            1.2),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: SizeConfig.instance.blockSizeVertical *
                                        2),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Container(
                                        child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: SizeConfig.instance
                                                      .blockSizeHorizontal *
                                                  2),
                                          child: Container(
                                            height: SizeConfig.instance
                                                    .blockSizeVertical *
                                                2.2,
                                            width: SizeConfig.instance
                                                    .blockSizeVertical *
                                                2.2,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/up-arrow.png'),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '0',
                                          style: TextStyle(
                                              color: _sideTextColor,
                                              fontSize: SizeConfig.instance
                                                      .blockSizeVertical *
                                                  1.8,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )),
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right: SizeConfig.instance
                                                        .blockSizeHorizontal *
                                                    2),
                                            child: Icon(
                                              Icons.mode_comment,
                                              size: SizeConfig.instance
                                                      .blockSizeVertical *
                                                  2.2,
                                              color: _sideTextColor,
                                            ),
                                          ),
                                          Text(
                                            'Comment',
                                            style: TextStyle(
                                                color: _sideTextColor,
                                                fontSize: SizeConfig.instance
                                                        .blockSizeVertical *
                                                    1.8,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
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
