import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_frontend/components/app_logo.dart';
import 'package:canteen_frontend/screens/profile/add_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupPicture extends StatelessWidget {
  final String photoUrl;
  final BoxShape shape;
  final double size;
  final Function onTap;

  GroupPicture(
      {@required this.photoUrl,
      this.shape = BoxShape.circle,
      this.size = 160,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    if (photoUrl != null && photoUrl.isNotEmpty) {
      return Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(photoUrl),
            fit: BoxFit.cover,
          ),
          shape: shape,
        ),
      );
    }

    return AppLogo(
      size: size,
    );
  }
}
