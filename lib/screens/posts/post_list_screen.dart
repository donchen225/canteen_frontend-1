import 'package:canteen_frontend/components/view_user_profile_screen.dart';
import 'package:canteen_frontend/models/arguments.dart';
import 'package:canteen_frontend/models/like/like.dart';
import 'package:canteen_frontend/screens/posts/arguments.dart';
import 'package:canteen_frontend/screens/posts/bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/comment_bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/comment_button.dart';
import 'package:canteen_frontend/screens/posts/like_button.dart';
import 'package:canteen_frontend/screens/posts/post_container.dart';
import 'package:canteen_frontend/screens/posts/post_list_bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/post_name_template.dart';
import 'package:canteen_frontend/screens/posts/single_post_screen.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final curentUserId =
        CachedSharedPreferences.getString(PreferenceConstants.userId);
    final TextStyle buttonTextStyle = Theme.of(context).textTheme.bodyText2;

    return BlocBuilder<PostListBloc, PostListState>(
      builder: (BuildContext context, PostListState state) {
        print('POST LIST SCREEN');
        print(state);

        if (state is PostListLoading) {
          return Center(
            child: CupertinoActivityIndicator(),
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
                  final post = state.posts[index];

                  return GestureDetector(
                    onTap: () {
                      BlocProvider.of<CommentBloc>(context).add(LoadComments(
                          groupId: state.groupId, postId: post.id));
                      Navigator.pushNamed(
                        context,
                        SinglePostScreen.routeName,
                        arguments: SinglePostArguments(
                          post: post,
                          groupId: state.groupId,
                        ),
                      );
                    },
                    child: PostContainer(
                        padding: EdgeInsets.only(
                          left: SizeConfig.instance.blockSizeHorizontal * 4,
                          right: SizeConfig.instance.blockSizeHorizontal * 4,
                          top: SizeConfig.instance.blockSizeHorizontal * 3,
                          bottom: SizeConfig.instance.blockSizeHorizontal * 3,
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  ViewUserProfileScreen.routeName,
                                  arguments: UserArguments(
                                    user: post.user,
                                  ),
                                ),
                                child: Container(
                                  alignment: Alignment.topCenter,
                                  child: ProfilePicture(
                                    photoUrl: post.user.photoUrl,
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
                                        name: post.user.displayName,
                                        title: post.user.title,
                                        photoUrl: post.user.photoUrl,
                                        time: post.createdOn,
                                        color: Palette.textSecondaryBaseColor,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: SizeConfig
                                                .instance.safeBlockVertical),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            post.message,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (!(post.liked)) {
                                                    final like = Like(
                                                        from: curentUserId,
                                                        createdOn:
                                                            DateTime.now());
                                                    BlocProvider.of<PostBloc>(
                                                            context)
                                                        .add(AddLike(
                                                            groupId:
                                                                state.groupId,
                                                            postId: post.id,
                                                            like: like));
                                                  } else {
                                                    BlocProvider.of<PostBloc>(
                                                            context)
                                                        .add(DeleteLike(
                                                            groupId:
                                                                state.groupId,
                                                            postId: post.id));
                                                  }
                                                },
                                                child: LikeButton(
                                                    post: post,
                                                    sideTextColor: Palette
                                                        .textSecondaryBaseColor,
                                                    style: buttonTextStyle),
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
                }, childCount: state.posts.length),
              ),
            ],
          );
        }

        return Container();
      },
    );
  }
}
