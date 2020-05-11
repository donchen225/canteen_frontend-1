import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final User user;
  final Function onTap;
  final double height;
  final double width;

  const ProfileCard({
    Key key,
    this.onTap,
    this.height = 400,
    this.width = 300,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(kCardCircularRadius),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            Container(
              height: height * 0.5,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(kCardCircularRadius),
                  topRight: Radius.circular(kCardCircularRadius),
                ),
                image: DecorationImage(
                  image: (user.photoUrl != null && user.photoUrl.isNotEmpty)
                      ? CachedNetworkImageProvider(user.photoUrl)
                      : AssetImage('assets/blank-profile-picture.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: width,
              padding: EdgeInsets.only(
                top: SizeConfig.instance.safeBlockVertical * 2,
                bottom: SizeConfig.instance.safeBlockVertical * 2,
                left: SizeConfig.instance.safeBlockHorizontal * 6,
                right: SizeConfig.instance.safeBlockHorizontal * 6,
              ),
              child: Column(
                children: <Widget>[
                  Visibility(
                    visible: user.title?.isNotEmpty ?? false,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: SizeConfig.instance.safeBlockVertical),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(user.title ?? '',
                            style: Theme.of(context).textTheme.headline6),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: user.teachSkill.length != 0,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: user.teachSkill.length,
                      itemBuilder: (context, index) {
                        final skill = user.teachSkill[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 1),
                          child: Text(
                            skill.name,
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        );
                      },
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
