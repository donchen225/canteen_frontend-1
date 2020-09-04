import 'package:canteen_frontend/components/platform/platform_loading_indicator.dart';
import 'package:canteen_frontend/components/view_user_profile_screen.dart';
import 'package:canteen_frontend/models/arguments.dart';
import 'package:canteen_frontend/models/like/like.dart';
import 'package:canteen_frontend/screens/posts/bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/comment_button.dart';
import 'package:canteen_frontend/screens/posts/comment_list_bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/group_single_post_screen.dart';
import 'package:canteen_frontend/screens/posts/like_button.dart';
import 'package:canteen_frontend/screens/posts/post_container.dart';
import 'package:canteen_frontend/screens/posts/post_list_bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/post_name_template.dart';
import 'package:canteen_frontend/screens/posts/single_post_bloc/bloc.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostListScreen extends StatefulWidget {
  PostListScreen();

  @override
  _PostListScreenState createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userId =
        CachedSharedPreferences.getString(PreferenceConstants.userId);
    final buttonTextStyle = Theme.of(context).textTheme.bodyText2;

    return BlocBuilder<PostListBloc, PostListState>(
      bloc: BlocProvider.of<PostListBloc>(context),
      builder: (BuildContext context, PostListState state) {
        if (state is PostListLoading) {
          return Center(
            child: PlatformLoadingIndicator(),
          );
        }

        if (state is PostListPrivate) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.instance.safeBlockHorizontal * 10,
              ),
              child: Text(
                'Posts are private. Join the group to view posts.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          );
        }

        if (state is PostListLoaded) {
          return CustomScrollView(
            key: PageStorageKey<String>('posts'),
            slivers: <Widget>[
              SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  final post = state.postList[index];

                  return GestureDetector(
                    onTap: () {
                      BlocProvider.of<SinglePostBloc>(context).add(
                          LoadSinglePost(post: post, groupId: state.groupId));
                      BlocProvider.of<CommentListBloc>(context).add(
                          LoadCommentList(
                              groupId: state.groupId, postId: post.id));
                      Navigator.pushNamed(
                        context,
                        GroupSinglePostScreen.routeName,
                      );
                    },
                    child: PostContainer(
                        padding: EdgeInsets.only(
                          left: SizeConfig.instance.blockSizeHorizontal * 4,
                          right: SizeConfig.instance.blockSizeHorizontal * 4,
                          top: SizeConfig.instance.safeBlockVertical * 1.5,
                          bottom: SizeConfig.instance.safeBlockVertical * 0.5,
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  if (post.user != null) {
                                    Navigator.pushNamed(
                                      context,
                                      ViewUserProfileScreen.routeName,
                                      arguments: UserArguments(
                                        user: post.user,
                                      ),
                                    ).then((value) {
                                      setState(() {});
                                    });
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.topCenter,
                                  child: ProfilePicture(
                                    photoUrl: post.user?.photoUrl ?? '',
                                    editable: false,
                                    size: SizeConfig
                                            .instance.safeBlockHorizontal *
                                        15,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: SizeConfig
                                            .instance.blockSizeHorizontal *
                                        2,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      PostNameTemplate(
                                        name: post.user?.displayName ?? null,
                                        title: post.user?.title ?? '',
                                        photoUrl: post.user?.photoUrl ?? '',
                                        time: post.createdOn,
                                        color: Palette.textSecondaryBaseColor,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: SizeConfig.instance
                                                    .safeBlockVertical *
                                                0.5,
                                            bottom: SizeConfig.instance
                                                    .safeBlockVertical *
                                                0.5),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            post.message,
                                            style: buttonTextStyle,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Expanded(
                                              child: LikeButton(
                                                liked: post.liked,
                                                likeCount: post.likeCount,
                                                color: Palette
                                                    .textSecondaryBaseColor,
                                                onTap: () {
                                                  final postBloc =
                                                      BlocProvider.of<PostBloc>(
                                                          context);

                                                  if (!(post.liked)) {
                                                    final like = Like(
                                                        from: userId,
                                                        createdOn:
                                                            DateTime.now());
                                                    postBloc.add(AddLike(
                                                        groupId: state.groupId,
                                                        postId: post.id,
                                                        like: like));
                                                  } else {
                                                    postBloc.add(DeleteLike(
                                                        groupId: state.groupId,
                                                        postId: post.id));
                                                  }
                                                },
                                              ),
                                            ),
                                            Expanded(
                                              child: CommentButton(
                                                  post: post,
                                                  style: buttonTextStyle,
                                                  sideTextColor: Palette
                                                      .textSecondaryBaseColor),
                                            ),
                                            Expanded(
                                              child: Container(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  );
                }, childCount: state.postList.length),
              ),
            ],
          );
        }

        return Container();
      },
    );
  }
}
