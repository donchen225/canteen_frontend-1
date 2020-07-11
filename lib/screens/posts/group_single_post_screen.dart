import 'package:canteen_frontend/screens/posts/comment_list_bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/single_post_bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/single_post_body.dart';
import 'package:canteen_frontend/screens/posts/single_post_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupSinglePostScreen extends StatefulWidget {
  static const routeName = '/post';

  @override
  _GroupSinglePostScreenState createState() => _GroupSinglePostScreenState();
}

class _GroupSinglePostScreenState extends State<GroupSinglePostScreen> {
  @override
  Widget build(BuildContext context) {
    return SinglePostScreen(
      body: BlocListener<SinglePostBloc, SinglePostState>(
        listener: (BuildContext context, SinglePostState state) {
          print('BLOC LISTENER: $state');
          if (state is SinglePostLoaded) {
            BlocProvider.of<CommentListBloc>(context).add(
                LoadCommentList(groupId: state.groupId, postId: state.post.id));
          }
        },
        child: BlocBuilder<SinglePostBloc, SinglePostState>(
          builder: (BuildContext context, SinglePostState state) {
            if (state is SinglePostLoading) {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }

            if (state is SinglePostLoaded) {
              return SinglePostBody(
                post: state.post,
                groupId: state.groupId,
              );
            }

            return Container();
          },
        ),
      ),
    );
  }
}
