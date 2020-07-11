import 'package:canteen_frontend/components/app_logo.dart';
import 'package:canteen_frontend/components/custom_card.dart';
import 'package:canteen_frontend/components/group_picture.dart';
import 'package:canteen_frontend/models/group/group.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/material.dart';

class GroupCard extends StatelessWidget {
  final Group group;
  final double height;
  final double width;
  final Color color;
  final Function onTap;
  final double kHorizontalPadding = 0.08;

  GroupCard(
      {@required this.group,
      this.height = 400,
      this.width = 250,
      this.color = const Color(0xFFFFFF),
      this.onTap})
      : assert(group != null);

  @override
  Widget build(BuildContext context) {
    final bodyTextStyle = Theme.of(context).textTheme.bodyText2;
    final titleStyle = Theme.of(context).textTheme.headline5;
    final subtitleStyle = Theme.of(context).textTheme.subtitle1;

    return CustomCard(
      height: height,
      width: width,
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: height * 0.08),
            child: GroupPicture(
              photoUrl: group.photoUrl,
              shape: BoxShape.circle,
              size: height * 0.25,
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * kHorizontalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    group.name,
                    style: titleStyle.apply(fontWeightDelta: 2),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: height * 0.02),
                    child: Text(
                      '${group.type[0].toUpperCase() + group.type.substring(1)} Group',
                      style: subtitleStyle.apply(
                          color: Palette.textSecondaryBaseColor),
                    ),
                  ),
                  Text(
                    group.description,
                    textAlign: TextAlign.left,
                    style: bodyTextStyle,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: height * 0.06),
            child: Text(
              '${group.members.toString()} members',
              style: subtitleStyle.apply(color: Palette.textSecondaryBaseColor),
            ),
          )
        ],
      ),
    );
  }
}
