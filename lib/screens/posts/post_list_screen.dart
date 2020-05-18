import 'package:canteen_frontend/models/like/like.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/posts/bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/comment_bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/comment_button.dart';
import 'package:canteen_frontend/screens/posts/enter_post_box.dart';
import 'package:canteen_frontend/screens/posts/like_button.dart';
import 'package:canteen_frontend/screens/posts/post_container.dart';
import 'package:canteen_frontend/screens/posts/post_name_template.dart';
import 'package:canteen_frontend/screens/posts/post_screen_bloc/bloc.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostListScreen extends StatelessWidget {
  final User user;

  PostListScreen({this.user}) : assert(user != null);

  @override
  Widget build(BuildContext context) {
    final TextStyle bodyTextTheme = Theme.of(context).textTheme.bodyText1;

    return BlocBuilder<PostBloc, PostState>(
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
                  user: user,
                ),
              ),
            ),
            SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                final post = state.posts[index];

                return Padding(
                  padding: EdgeInsets.only(
                      bottom: SizeConfig.instance.safeBlockVertical * 0.5),
                  child: GestureDetector(
                    onTap: () {
                      BlocProvider.of<CommentBloc>(context)
                          .add(LoadComments(postId: post.id));
                      BlocProvider.of<PostScreenBloc>(context)
                          .add(PostsInspectPost(post));
                    },
                    child: PostContainer(
                        padding: EdgeInsets.only(
                          left: SizeConfig.instance.blockSizeHorizontal * 4,
                          right: SizeConfig.instance.blockSizeHorizontal * 4,
                          top: SizeConfig.instance.blockSizeHorizontal * 3,
                          bottom: SizeConfig.instance.blockSizeHorizontal * 3,
                        ),
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () =>
                                  BlocProvider.of<PostScreenBloc>(context)
                                      .add(PostsInspectUser(post.user)),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom:
                                        SizeConfig.instance.safeBlockVertical),
                                child: PostNameTemplate(
                                  name: post.user.displayName,
                                  photoUrl: post.user.photoUrl,
                                  time: post.createdOn,
                                  color: Palette.textSecondaryBaseColor,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  bottom:
                                      SizeConfig.instance.safeBlockVertical *
                                          0.5),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  post.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .apply(fontWeightDelta: 1),
                                ),
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
                                  top: SizeConfig.instance.safeBlockVertical *
                                      2),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      if (!(post.liked)) {
                                        final like = Like(
                                            from: user.id,
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
                                        sideTextColor:
                                            Palette.textSecondaryBaseColor,
                                        style: bodyTextTheme),
                                  ),
                                  CommentButton(
                                      sideTextColor:
                                          Palette.textSecondaryBaseColor),
                                  Container(),
                                ],
                              ),
                            ),
                          ],
                        )),
                  ),
                );
              }, childCount: state.posts.length),
            ),
          ]);
        }

        return Container();
      },
    );
  }
}
