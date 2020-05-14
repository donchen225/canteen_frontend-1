import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_frontend/screens/profile/add_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  final String photoUrl;
  final BoxShape shape;
  final bool editable;
  final double size;
  final Function onTap;

  ProfilePicture(
      {@required this.photoUrl,
      this.shape = BoxShape.circle,
      this.editable = false,
      this.size = 160,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        image: DecorationImage(
          // TODO: fix profile picture is updated locally first
          image: (photoUrl != null && photoUrl.isNotEmpty)
              ? CachedNetworkImageProvider(photoUrl)
              : AssetImage('assets/blank-profile-picture.jpeg'),
          fit: BoxFit.cover,
        ),
        shape: shape,
      ),
      child: editable
          ? Align(
              alignment: Alignment.bottomRight,
              child: AddIcon(
                size,
                onTap: onTap != null ? onTap : () {},
              ),
            )
          : Container(),
    );
  }
}
