import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final User user;
  final int skillIndex;
  final Function onTap;
  final double height;
  final double width;

  const ProfileCard({
    Key key,
    this.onTap,
    this.skillIndex = 0,
    this.height = 400,
    this.width = 300,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final skill =
        user.teachSkill.isNotEmpty ? user.teachSkill[skillIndex] : null;

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
              height: height * 0.45,
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
            Expanded(
              child: Container(
                width: width,
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.grey[100],
                      padding: EdgeInsets.only(
                        top: SizeConfig.instance.safeBlockVertical,
                        bottom: SizeConfig.instance.safeBlockVertical,
                        left: SizeConfig.instance.safeBlockHorizontal * 6,
                        right: SizeConfig.instance.safeBlockHorizontal * 6,
                      ),
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              user.displayName ?? '',
                              style:
                                  Theme.of(context).textTheme.subtitle1.apply(
                                        fontWeightDelta: 2,
                                      ),
                            ),
                          ),
                          Visibility(
                            visible: user.title?.isNotEmpty ?? false,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(user.title ?? '',
                                  style: Theme.of(context).textTheme.subtitle2),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(
                          left: SizeConfig.instance.safeBlockHorizontal * 6,
                          right: SizeConfig.instance.safeBlockHorizontal * 6,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Visibility(
                              visible: skill != null && skill?.name != null,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: SizeConfig.instance.safeBlockVertical,
                                  bottom: SizeConfig.instance.safeBlockVertical,
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    skill?.name != null
                                        ? skill.name[0].toUpperCase() +
                                            skill.name.substring(1)
                                        : '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .apply(
                                          color: Palette.titleColor,
                                          fontWeightDelta: 2,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: skill != null && skill?.name != null,
                              child: Builder(builder: (BuildContext context) {
                                final duration = skill?.duration != null
                                    ? '${skill.duration.toString()}m'
                                    : '';
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom:
                                        SizeConfig.instance.safeBlockVertical *
                                            2,
                                  ),
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          duration,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2
                                              .apply(
                                                color: Palette.orangeColor,
                                                fontWeightDelta: 2,
                                              ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: SizeConfig.instance
                                                  .blockSizeHorizontal),
                                          child: Container(
                                            width: SizeConfig
                                                .instance.blockSizeHorizontal,
                                            height: SizeConfig
                                                .instance.blockSizeHorizontal,
                                            decoration: BoxDecoration(
                                              color: Palette.titleColor,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '\$${skill.price}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2
                                              .apply(
                                                color: Palette.titleColor,
                                                fontWeightDelta: 2,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
