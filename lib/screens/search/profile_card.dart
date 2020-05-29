import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_frontend/components/custom_card.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final User user;
  final int skillIndex;
  final Function onTap;
  final double height;
  final double width;
  final double kHorizontalPadding = 0.08;

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

    return CustomCard(
      height: height,
      width: width,
      onTap: onTap,
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
                      top: height * 0.03,
                      bottom: height * 0.03,
                      left: width * kHorizontalPadding,
                      right: width * kHorizontalPadding,
                    ),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            user.displayName ?? '',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        Visibility(
                          visible: user.title?.isNotEmpty ?? false,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(user.title ?? '',
                                style: Theme.of(context).textTheme.bodyText2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(
                        left: width * kHorizontalPadding,
                        right: width * kHorizontalPadding,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Visibility(
                            visible: skill != null && skill?.name != null,
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: height * 0.03,
                                bottom: height * 0.03,
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
                                  bottom: height * 0.06,
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
                                              color: Palette.primaryColor,
                                              fontWeightDelta: 2,
                                            ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width * 0.02),
                                        child: Container(
                                          width: kDotSize,
                                          height: kDotSize,
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
    );
  }
}
