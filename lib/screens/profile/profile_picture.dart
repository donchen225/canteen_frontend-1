import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_frontend/screens/profile/add_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  final String photoUrl;
  final String additionalPhotoUrl;
  final BoxShape shape;
  final bool editable;
  final double size;
  final Function onTap;

  ProfilePicture(
      {@required this.photoUrl,
      this.additionalPhotoUrl,
      this.shape = BoxShape.circle,
      this.editable = false,
      this.size = 160,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    if (additionalPhotoUrl != null) {
      return Container(
        height: size,
        width: size,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                height: size / 1.6,
                width: size / 1.6,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: (additionalPhotoUrl.isNotEmpty)
                        ? CachedNetworkImageProvider(additionalPhotoUrl)
                        : AssetImage('assets/blank-profile-picture.png'),
                    fit: BoxFit.cover,
                  ),
                  shape: shape,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: (size / 1.6) + 6,
                width: (size / 1.6) + 6,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                  image: DecorationImage(
                    image: (photoUrl != null && photoUrl.isNotEmpty)
                        ? CachedNetworkImageProvider(photoUrl)
                        : AssetImage('assets/blank-profile-picture.png'),
                    fit: BoxFit.cover,
                  ),
                  shape: shape,
                ),
              ),
            )
          ],
        ),
      );
    }

    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        image: DecorationImage(
          // TODO: fix profile picture is updated locally first
          image: (photoUrl != null && photoUrl.isNotEmpty)
              ? CachedNetworkImageProvider(photoUrl)
              : AssetImage('assets/blank-profile-picture.png'),
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
