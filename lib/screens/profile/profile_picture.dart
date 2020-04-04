import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  final String photoUrl;
  final ImageProvider localPicture;
  final bool editable;
  final double size;

  ProfilePicture(
      {@required this.photoUrl,
      @required this.localPicture,
      @required this.editable,
      this.size = 160});

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
              child: Container(
                height: size / 4,
                width: size / 4,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.white,
                  ),
                  color: Colors.blue[500],
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  CupertinoIcons.add,
                  color: Colors.white,
                  size: size / 5,
                ),
              ),
            )
          : Container(),
    );
  }
}
