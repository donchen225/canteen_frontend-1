import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/posts/comment_bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/comment_dialog_screen.dart';
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 1,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: SizeConfig.instance.blockSizeVertical * 2,
                left: SizeConfig.instance.blockSizeHorizontal * 4,
                right: SizeConfig.instance.blockSizeHorizontal * 4,
              ),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: PostNameTemplate(
                      name: post.user.displayName,
                      photoUrl: post.user.photoUrl,
                      time: post.createdOn,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.instance.blockSizeVertical * 2,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          post.title,
                          style: TextStyle(
                            fontSize: SizeConfig.instance.blockSizeVertical *
                                2.4 *
                                1.2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(post.message)),
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
                        return Container();
                      }),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Padding(
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
                        bottom: BorderSide(
                          width: 1,
                          color: Colors.grey[100],
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                            child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  right:
                                      SizeConfig.instance.blockSizeHorizontal *
                                          2),
                              child: Container(
                                height:
                                    SizeConfig.instance.blockSizeVertical * 2.2,
                                width:
                                    SizeConfig.instance.blockSizeVertical * 2.2,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/up-arrow.png'),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              '0',
                              style: TextStyle(
                                  color: _sideTextColor,
                                  fontSize:
                                      SizeConfig.instance.blockSizeVertical *
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
                                    right: SizeConfig
                                            .instance.blockSizeHorizontal *
                                        2),
                                child: Icon(
                                  Icons.mode_comment,
                                  size: SizeConfig.instance.blockSizeVertical *
                                      2.2,
                                  color: _sideTextColor,
                                ),
                              ),
                              Text(
                                'Comment',
                                style: TextStyle(
                                    color: _sideTextColor,
                                    fontSize:
                                        SizeConfig.instance.blockSizeVertical *
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
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: SizeConfig.instance.blockSizeHorizontal * 3,
                    right: SizeConfig.instance.blockSizeHorizontal * 3,
                    bottom: SizeConfig.instance.safeBlockVertical * 3,
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
