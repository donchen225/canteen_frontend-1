import 'dart:async';

import 'package:canteen_frontend/components/dot_spacer.dart';
import 'package:canteen_frontend/components/unauthenticated_functions.dart';
import 'package:canteen_frontend/components/view_user_profile_screen.dart';
import 'package:canteen_frontend/models/arguments.dart';
import 'package:canteen_frontend/models/like/like.dart';
import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/screens/posts/bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/comment_button.dart';
import 'package:canteen_frontend/screens/posts/comment_container.dart';
import 'package:canteen_frontend/screens/posts/comment_dialog_screen.dart';
import 'package:canteen_frontend/screens/posts/comment_list_bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/like_button.dart';
import 'package:canteen_frontend/screens/posts/post_name_template.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/shared_blocs/authentication/bloc.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'bloc/post_bloc.dart';

class SinglePostBody extends StatefulWidget {
  const SinglePostBody({
    Key key,
    @required this.post,
    @required this.groupId,
  }) : super(key: key);

  final DetailedPost post;
  final String groupId;

  @override
  _SinglePostBodyState createState() => _SinglePostBodyState();
}

class _SinglePostBodyState extends State<SinglePostBody> {
  ScrollController _scrollController;
  bool _shouldScrollToBottom = false;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _scrollToBottom() async {
    if (_shouldScrollToBottom) {
      // TODO: remove this hack
      Timer(
          Duration(milliseconds: 500),
          () => _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 300),
              ));

      _shouldScrollToBottom = false;
    }
  }

  void _onTapComment(BuildContext context) async {
    final authenticated =
        BlocProvider.of<AuthenticationBloc>(context).state is Authenticated;

    if (authenticated) {
      final commented = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => CommentDialogScreen(
          post: widget.post,
          groupId: widget.groupId,
          height:
              SizeConfig.instance.blockSizeVertical * kDialogScreenHeightBlocks,
        ),
      );

      if (commented) {
        _shouldScrollToBottom = true;
      }
    } else {
      UnauthenticatedFunctions.showSignUp(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final curentUserId =
        CachedSharedPreferences.getString(PreferenceConstants.userId);
    final TextStyle secondaryTextTheme = Theme.of(context).textTheme.bodyText2;

    return Column(
      children: <Widget>[
        Expanded(
          child: CustomScrollView(
            controller: _scrollController,
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
                          onTap: () {
                            if (widget.post.user != null) {
                              Navigator.pushNamed(
                                context,
                                ViewUserProfileScreen.routeName,
                                arguments: UserArguments(
                                  user: widget.post.user,
                                ),
                              );
                            }
                          },
                          child: Row(
                            children: <Widget>[
                              ProfilePicture(
                                photoUrl: widget.post.user.photoUrl,
                                editable: false,
                                size: SizeConfig.instance.safeBlockHorizontal *
                                    12,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig
                                            .instance.safeBlockHorizontal *
                                        2,
                                  ),
                                  child: PostNameTemplate(
                                    name: widget.post.user.displayName,
                                    title: widget.post.user.title,
                                    photoUrl: widget.post.user.photoUrl,
                                    showDate: false,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          top: SizeConfig.instance.safeBlockVertical * 2,
                          bottom: SizeConfig.instance.safeBlockVertical * 2,
                          left: SizeConfig.instance.safeBlockHorizontal *
                              kHorizontalPaddingBlocks,
                          right: SizeConfig.instance.safeBlockHorizontal *
                              kHorizontalPaddingBlocks,
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.post.message,
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              .apply(fontWeightDelta: -1),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: SizeConfig.instance.safeBlockHorizontal *
                              kHorizontalPaddingBlocks,
                          right: SizeConfig.instance.safeBlockHorizontal *
                              kHorizontalPaddingBlocks,
                          bottom: SizeConfig.instance.safeBlockVertical * 0.5,
                        ),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: <Widget>[
                            Text(
                                DateFormat('yMMMMd')
                                    .format(widget.post.createdOn),
                                style: secondaryTextTheme.apply(
                                    color: Palette.textSecondaryBaseColor)),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig
                                        .instance.safeBlockHorizontal),
                                child: DotSpacer()),
                            Text(DateFormat.jm().format(widget.post.createdOn),
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
                            top: SizeConfig.instance.safeBlockVertical * 0.5,
                            bottom: SizeConfig.instance.safeBlockVertical * 0.5,
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
                              LikeButton(
                                liked: widget.post.liked,
                                likeCount: widget.post.likeCount,
                                color: Palette.textSecondaryBaseColor,
                                size: 32,
                                onTap: () {
                                  final postBloc =
                                      BlocProvider.of<PostBloc>(context);

                                  if (!(widget.post.liked)) {
                                    final like = Like(
                                        from: curentUserId,
                                        createdOn: DateTime.now());
                                    postBloc.add(AddLike(
                                        groupId: widget.groupId,
                                        postId: widget.post.id,
                                        like: like));
                                  } else {
                                    postBloc.add(DeleteLike(
                                        groupId: widget.groupId,
                                        postId: widget.post.id));
                                  }
                                },
                              ),
                              GestureDetector(
                                onTap: () => _onTapComment(context),
                                child: CommentButton(
                                  post: widget.post,
                                  style: secondaryTextTheme,
                                  sideTextColor: Palette.textSecondaryBaseColor,
                                  size: 32,
                                ),
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
                child: BlocBuilder<CommentListBloc, CommentListState>(
                    builder: (BuildContext context, CommentListState state) {
                  if (state is CommentListLoading) {
                    return Container(
                        height: SizeConfig.instance.safeBlockVertical * 40,
                        child: CupertinoActivityIndicator());
                  }

                  if (state is CommentListLoaded) {
                    _scrollToBottom();
                    final comments = state.commentList;

                    return ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: comments.length,
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
                  onTap: () => _onTapComment(context),
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
                              .bodyText2
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
    );
  }
}
