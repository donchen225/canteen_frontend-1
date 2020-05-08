import 'package:canteen_frontend/models/like/like.dart';
import 'package:canteen_frontend/screens/posts/bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/comment_bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/enter_post_box.dart';
import 'package:canteen_frontend/screens/posts/post_container.dart';
import 'package:canteen_frontend/screens/posts/post_name_template.dart';
import 'package:canteen_frontend/screens/posts/single_post_screen.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostScreen extends StatelessWidget {
  final Color _sideTextColor = Colors.grey[500];

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
                                Padding(
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
                                        child: Container(
                                            padding: EdgeInsets.only(
                                              left: SizeConfig.instance
                                                      .blockSizeHorizontal *
                                                  3,
                                              right: SizeConfig.instance
                                                      .blockSizeHorizontal *
                                                  3,
                                            ),
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
                                                    child: Image.asset(
                                                      'assets/up-arrow.png',
                                                      color: post.liked
                                                          ? Colors.blue
                                                          : _sideTextColor,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  post.likeCount.toString(),
                                                  style: TextStyle(
                                                      color: post.liked
                                                          ? Colors.blue
                                                          : _sideTextColor,
                                                      fontSize: SizeConfig
                                                              .instance
                                                              .blockSizeVertical *
                                                          1.8,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            )),
                                      ),
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
