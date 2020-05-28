import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:flutter/material.dart';

class ProfileSideBarButton extends StatelessWidget {
  final Function onPressed;

  const ProfileSideBarButton({
    Key key,
    @required this.userPhotoUrl,
    @required this.onPressed,
  }) : super(key: key);

  final String userPhotoUrl;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        icon: ProfilePicture(
          photoUrl: userPhotoUrl,
          editable: false,
          size: kProfileIconSize,
        ),
        onPressed: () {
          if (onPressed != null) {
            onPressed();
          }
        },
      ),
    );
  }
}
