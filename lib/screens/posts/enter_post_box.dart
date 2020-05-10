import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/posts/post_container.dart';
import 'package:canteen_frontend/screens/posts/post_dialog_screen.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class EnterPostBox extends StatelessWidget {
  final User user;

  EnterPostBox({@required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => PostDialogScreen(
            user: user,
          ),
        );
      },
      child: PostContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  bottom: SizeConfig.instance.blockSizeVertical),
              child: Row(
                children: <Widget>[
                  ProfilePicture(
                    photoUrl: user.photoUrl,
                    editable: false,
                    size: SizeConfig.instance.blockSizeHorizontal * 6,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.instance.blockSizeHorizontal),
                    child: Text(
                      user.displayName ?? '',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'What is your question?',
              style: Theme.of(context).textTheme.headline6.apply(
                    color: Colors.grey,
                    fontWeightDelta: 1,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
