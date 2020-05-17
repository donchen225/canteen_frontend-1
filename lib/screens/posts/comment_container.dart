import 'package:canteen_frontend/models/comment/comment.dart';
import 'package:canteen_frontend/screens/posts/post_container.dart';
import 'package:canteen_frontend/screens/posts/post_name_template.dart';
import 'package:canteen_frontend/screens/posts/post_screen_bloc/bloc.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentContainer extends StatelessWidget {
  final DetailedComment comment;

  CommentContainer({@required this.comment});

  @override
  Widget build(BuildContext context) {
    return PostContainer(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                bottom: SizeConfig.instance.blockSizeVertical * 2),
            child: GestureDetector(
              onTap: () {
                BlocProvider.of<PostScreenBloc>(context)
                    .add(PostsInspectUser(comment.user));
              },
              child: PostNameTemplate(
                name: comment.user.displayName,
                photoUrl: comment.user.photoUrl,
                time: comment.createdOn,
                color: Palette.textSecondaryBaseColor,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              comment.message,
            ),
          ),
        ],
      ),
    );
  }
}
