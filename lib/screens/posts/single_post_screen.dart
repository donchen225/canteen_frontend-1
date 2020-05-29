import 'package:canteen_frontend/components/dot_spacer.dart';
import 'package:canteen_frontend/models/like/like.dart';
import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/posts/bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/comment_bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/comment_button.dart';
import 'package:canteen_frontend/screens/posts/comment_container.dart';
import 'package:canteen_frontend/screens/posts/comment_dialog_screen.dart';
import 'package:canteen_frontend/screens/posts/like_button.dart';
import 'package:canteen_frontend/screens/posts/post_name_template.dart';
import 'package:canteen_frontend/screens/posts/post_screen_bloc/bloc.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SinglePostScreen extends StatelessWidget {
  final User user;
  final DetailedPost post;
  final Function onTapBack;
  final Color _sideTextColor = Colors.grey[500];

  SinglePostScreen(
      {@required this.post, @required this.user, @required this.onTapBack});

  @override
  Widget build(BuildContext context) {
    final TextStyle secondaryTextTheme = Theme.of(context).textTheme.bodyText2;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.containerColor,
        elevation: 1,
        leading: BackButton(
          color: Palette.primaryColor,
          onPressed: () {
            if (onTapBack != null) {
              onTapBack();
            }
          },
        ),
        title: Text('Posts'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: CustomScrollView(
              slivers: <Widget>[
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
                          child: GestureDetector(
                            onTap: () =>
                                BlocProvider.of<PostScreenBloc>(context)
                                    .add(PostsInspectUser(post.user)),
                            child: Row(
                              children: <Widget>[
                                ProfilePicture(
                                  photoUrl: post.user.photoUrl,
                                  editable: false,
                                  size:
                                      SizeConfig.instance.safeBlockHorizontal *
                                          12,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig
                                            .instance.safeBlockHorizontal *
                                        2,
                                  ),
                                  child: PostNameTemplate(
                                    name: post.user.displayName,
                                    title: post.user.title,
                                    photoUrl: post.user.photoUrl,
                                    showDate: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            top: SizeConfig.instance.safeBlockVertical,
                            bottom: SizeConfig.instance.safeBlockVertical,
                            left: SizeConfig.instance.safeBlockHorizontal *
                                kHorizontalPaddingBlocks,
                            right: SizeConfig.instance.safeBlockHorizontal *
                                kHorizontalPaddingBlocks,
                          ),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            post.message,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            left: SizeConfig.instance.safeBlockHorizontal *
                                kHorizontalPaddingBlocks,
                            right: SizeConfig.instance.safeBlockHorizontal *
                                kHorizontalPaddingBlocks,
                          ),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: <Widget>[
                              Text(DateFormat('yMMMMd').format(post.createdOn),
                                  style: secondaryTextTheme.apply(
                                      color: Palette.textSecondaryBaseColor)),
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: SizeConfig
                                          .instance.safeBlockHorizontal),
                                  child: DotSpacer()),
                              Text(DateFormat.jm().format(post.createdOn),
                                  style: secondaryTextTheme.apply(
                                      color: Palette.textSecondaryBaseColor)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: SizeConfig.instance.safeBlockVertical,
                          ),
                          child: Container(
                            padding: EdgeInsets.only(
                              top: SizeConfig.instance.safeBlockVertical * 1.5,
                              bottom:
                                  SizeConfig.instance.safeBlockVertical * 1.5,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  width: 1,
                                  color: Colors.grey[200],
                                ),
                                bottom: BorderSide(
                                  width: 1,
                                  color: Colors.grey[200],
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                    style: secondaryTextTheme,
                                    sideTextColor: _sideTextColor,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) => CommentDialogScreen(
                                        user: user,
                                        post: post,
                                        height: SizeConfig
                                                .instance.blockSizeVertical *
                                            kDialogScreenHeightBlocks,
                                      ),
                                    );
                                  },
                                  child: CommentButton(
                                      post: post,
                                      style: secondaryTextTheme,
                                      sideTextColor: _sideTextColor),
                                ),
                                Container(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: BlocBuilder<CommentBloc, CommentState>(
                      builder: (BuildContext context, CommentState state) {
                    if (state is CommentsLoading) {
                      return CupertinoActivityIndicator();
                    }

                    if (state is CommentsLoaded) {
                      final comments = state.comments;

                      return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: state.comments.length,
                          itemBuilder: (BuildContext context, int index) {
                            final comment = comments[index];

                            return CommentContainer(
                              comment: comment,
                            );
                          });
                    }

                    return Container();
                  }),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Palette.containerColor,
              border: Border(
                top: BorderSide(
                  width: 1,
                  color: Colors.grey[100],
                ),
              ),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    left: SizeConfig.instance.safeBlockHorizontal * 3,
                    right: SizeConfig.instance.safeBlockHorizontal * 3,
                    bottom: SizeConfig.instance.safeBlockVertical * 3,
                    top: SizeConfig.instance.safeBlockVertical * 2,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => CommentDialogScreen(
                          user: user,
                          post: post,
                          height: SizeConfig.instance.blockSizeVertical *
                              kDialogScreenHeightBlocks,
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.instance.safeBlockHorizontal * 3,
                      ),
                      height: SizeConfig.instance.safeBlockVertical * 5,
                      decoration: BoxDecoration(
                        color: Palette.scaffoldBackgroundDarkColor,
                        borderRadius: BorderRadius.circular(
                            SizeConfig.instance.safeBlockVertical * 5 * 0.5),
                      ),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Add a comment',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .apply(color: Palette.textSecondaryBaseColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
