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
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SinglePostScreen extends StatelessWidget {
  final User user;
  final DetailedPost post;
  final Color _sideTextColor = Colors.grey[500];

  SinglePostScreen({@required this.post, @required this.user});

  @override
  Widget build(BuildContext context) {
    final TextStyle bodyTextTheme = Theme.of(context).textTheme.bodyText1;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 1,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: SizeConfig.instance.blockSizeVertical * 2,
                      left: SizeConfig.instance.blockSizeHorizontal * 4,
                      right: SizeConfig.instance.blockSizeHorizontal * 4,
                    ),
                    child: PostNameTemplate(
                      name: post.user.displayName,
                      photoUrl: post.user.photoUrl,
                      time: post.createdOn,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: SizeConfig.instance.blockSizeVertical * 2,
                      bottom: SizeConfig.instance.blockSizeVertical * 2,
                      left: SizeConfig.instance.blockSizeHorizontal * 4,
                      right: SizeConfig.instance.blockSizeHorizontal * 4,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        post.title,
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .apply(fontWeightDelta: 2),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: SizeConfig.instance.blockSizeVertical,
                          left: SizeConfig.instance.blockSizeHorizontal * 4,
                          right: SizeConfig.instance.blockSizeHorizontal * 4,
                        ),
                        child: Text(post.message,
                            style: Theme.of(context).textTheme.bodyText1),
                      )),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: SizeConfig.instance.blockSizeVertical,
                      bottom: SizeConfig.instance.blockSizeVertical,
                    ),
                    child: Container(
                      padding: EdgeInsets.only(
                        top: SizeConfig.instance.blockSizeVertical * 2,
                        bottom: SizeConfig.instance.blockSizeVertical * 2,
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
                                    from: user.id, createdOn: DateTime.now());
                                BlocProvider.of<PostBloc>(context)
                                    .add(AddLike(post.id, like));
                              } else {
                                BlocProvider.of<PostBloc>(context)
                                    .add(DeleteLike(post.id));
                              }
                            },
                            child: LikeButton(
                              post: post,
                              style: bodyTextTheme,
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
                                ),
                              );
                            },
                            child: CommentButton(
                                style: bodyTextTheme,
                                sideTextColor: _sideTextColor),
                          ),
                          Container(),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.instance.blockSizeVertical * 2,
                  ),
                  sliver: SliverToBoxAdapter(
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

                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: SizeConfig.instance.blockSizeVertical,
                                ),
                                child: CommentContainer(
                                  comment: comment,
                                ),
                              );
                            });
                      }

                      return Container();
                    }),
                  ),
                )
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
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
                    left: SizeConfig.instance.blockSizeHorizontal * 3,
                    right: SizeConfig.instance.blockSizeHorizontal * 3,
                    bottom: SizeConfig.instance.safeBlockVertical * 3,
                    top: SizeConfig.instance.blockSizeVertical * 2,
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
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.instance.blockSizeHorizontal * 3,
                      ),
                      height: SizeConfig.instance.safeBlockVertical * 6,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                      ),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Add a comment',
                            style: TextStyle(color: Colors.grey[600]),
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
