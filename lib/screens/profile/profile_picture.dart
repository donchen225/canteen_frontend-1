import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_frontend/screens/profile/add_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  final String photoUrl;
  final ImageProvider localPicture;
  final bool editable;
  final double size;
  final Function onTap;

  ProfilePicture(
      {@required this.photoUrl,
      @required this.localPicture,
      @required this.editable,
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
              : localPicture,
          fit: BoxFit.cover,
        ),
        shape: BoxShape.circle,
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
