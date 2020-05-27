import 'package:canteen_frontend/models/comment/comment.dart';
import 'package:canteen_frontend/screens/posts/post_container.dart';
import 'package:canteen_frontend/screens/posts/post_name_template.dart';
import 'package:canteen_frontend/screens/posts/post_screen_bloc/bloc.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
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
      padding: EdgeInsets.only(
        left: SizeConfig.instance.blockSizeHorizontal * 4,
        right: SizeConfig.instance.blockSizeHorizontal * 4,
        top: SizeConfig.instance.blockSizeHorizontal * 3,
        bottom: SizeConfig.instance.blockSizeHorizontal * 3,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfilePicture(
              photoUrl: comment.user.photoUrl,
              editable: false,
              size: SizeConfig.instance.safeBlockHorizontal * 12,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.instance.safeBlockHorizontal * 2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      BlocProvider.of<PostScreenBloc>(context)
                          .add(PostsInspectUser(comment.user));
                    },
                    child: PostNameTemplate(
                      name: comment.user.displayName,
                      title: comment.user.title,
                      photoUrl: comment.user.photoUrl,
                      time: comment.createdOn,
                      color: Palette.textSecondaryBaseColor,
                      showDate: true,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.instance.safeBlockVertical),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      comment.message,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
