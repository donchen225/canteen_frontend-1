import 'package:canteen_frontend/components/custom_card.dart';
import 'package:canteen_frontend/components/group_picture.dart';
import 'package:canteen_frontend/models/group/group.dart';
import 'package:canteen_frontend/utils/constants.dart';
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
      this.width = 220,
      this.color = const Color(0xFFFFFF),
      this.onTap})
      : assert(group != null);

  @override
  Widget build(BuildContext context) {
    final bodyTextStyle = Theme.of(context).textTheme.bodyText2;
    final titleStyle = Theme.of(context).textTheme.headline5;

    return CustomCard(
      height: height,
      width: width,
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(kCardCircularRadius),
                topRight: Radius.circular(kCardCircularRadius),
              ),
              color: Palette.primaryColor.withOpacity(0.5),
            ),
            height: height * 0.3,
          ),
          Padding(
            padding: EdgeInsets.only(
              top: height * 0.06,
              bottom: height * 0.06,
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    bottom: height * 0.01,
                  ),
                  child: GroupPicture(
                    photoUrl: group.photoUrl,
                    shape: BoxShape.circle,
                    size: height * 0.3,
                  ),
                ),
                Expanded(
                  child: Container(
                    height: height * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Container(
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
                                  padding: EdgeInsets.only(
                                    bottom: height * 0.01,
                                  ),
                                  child: Text(
                                    '${group.type[0].toUpperCase() + group.type.substring(1)} Group',
                                    style: bodyTextStyle.apply(
                                        color: Palette.textSecondaryBaseColor),
                                  ),
                                ),
                                Text(
                                  group.description,
                                  textAlign: TextAlign.center,
                                  style: bodyTextStyle,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          '${group.members.toString()} members',
                          style: bodyTextStyle.apply(
                              color: Palette.textSecondaryBaseColor),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
