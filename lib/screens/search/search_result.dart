import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class SearchResult extends StatelessWidget {
  final User user;
  final double height;

  SearchResult({this.user, this.height = 100}) : assert(user != null);

  @override
  Widget build(BuildContext context) {
    final nameStyle = Theme.of(context).textTheme.subtitle1;

    return Container(
      height: 100,
      padding: EdgeInsets.only(
        left: SizeConfig.instance.safeBlockHorizontal * 6,
        right: SizeConfig.instance.safeBlockHorizontal * 6,
        top: height * 0.2,
        bottom: height * 0.2,
      ),
      child: Row(
        children: <Widget>[
          ProfilePicture(
            photoUrl: user.photoUrl,
            editable: false,
            size: height * 0.6,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.instance.safeBlockHorizontal * 3),
            child: Column(
              children: <Widget>[
                Text(
                  user.displayName,
                  style: nameStyle.apply(fontWeightDelta: 2),
                ),
                Text(
                  user.title ?? '',
                  style: nameStyle.apply(fontWeightDelta: 2),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
