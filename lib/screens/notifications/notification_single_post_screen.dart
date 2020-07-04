import 'package:canteen_frontend/screens/notifications/notification_view_bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/bloc/post_bloc.dart';
import 'package:canteen_frontend/screens/posts/comment_bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/single_post_body.dart';
import 'package:canteen_frontend/screens/posts/single_post_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationSinglePostScreen extends StatefulWidget {
  static const routeName = '/post';

  @override
  _NotificationSinglePostScreenState createState() =>
      _NotificationSinglePostScreenState();
}

class _NotificationSinglePostScreenState
    extends State<NotificationSinglePostScreen> {
  @override
  Widget build(BuildContext context) {
    return SinglePostScreen(
      onTapBack: () {
        BlocProvider.of<NotificationViewBloc>(context)
            .add(ClearNotificationView());
      },
      body: BlocListener<NotificationViewBloc, NotificationViewState>(
        listener: (BuildContext context, NotificationViewState state) {
          if (state is NotificationPostLoaded) {
            BlocProvider.of<CommentBloc>(context).add(
                LoadComments(groupId: state.groupId, postId: state.post.id));
          }
        },
        child: BlocBuilder<NotificationViewBloc, NotificationViewState>(
          builder: (BuildContext context, NotificationViewState state) {
            if (state is NotificationViewLoading) {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }

            if (state is NotificationPostLoaded) {
              return SinglePostBody(
                post: state.post,
                groupId: state.groupId,
                postBloc: BlocProvider.of<DiscoverPostBloc>(context),
              );
            }

            return Container();
          },
        ),
      ),
    );
  }
}
