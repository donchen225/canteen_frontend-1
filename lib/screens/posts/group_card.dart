import 'package:canteen_frontend/components/custom_card.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/material.dart';

class GroupCard extends StatelessWidget {
  final Map<String, dynamic> group;
  final double height;
  final double width;
  final Color color;
  final Function onTap;

  GroupCard(
      {@required this.group,
      this.height = 200,
      this.width = 180,
      this.color = const Color(0xFFFFFF),
      this.onTap})
      : assert(group != null);

  @override
  Widget build(BuildContext context) {
    final bodyTextStyle = Theme.of(context).textTheme.bodyText1;
    final titleStyle = Theme.of(context).textTheme.subtitle1;
    final subtitleStyle = Theme.of(context).textTheme.subtitle2;

    return CustomCard(
      height: height,
      width: width,
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Expanded(
              flex: 3,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      bottom: height * 0.1,
                    ),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(kCardCircularRadius),
                        topRight: Radius.circular(kCardCircularRadius),
                      ),
                    ),
                  ),
                  Container(
                    height: height * 0.3,
                    width: height * 0.3,
                    margin: EdgeInsets.only(
                      top: height * 0.05,
                    ),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 3,
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                  Container(
                    height: height * 0.2,
                    width: height * 0.2,
                    margin: EdgeInsets.only(
                      top: height * 0.05,
                    ),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    // constraints: BoxConstraints(maxHeight: 50, maxWidth: 50),
                    child: Image.asset(
                      'assets/loading-icon.png',
                      color: Colors.white,
                      // fit: BoxFit.fitHeight,
                    ),
                  ),
                ],
              )),
          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.05,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    group['name'],
                    style: titleStyle.apply(fontWeightDelta: 2),
                  ),
                  Text(
                    group['type'],
                    style: subtitleStyle.apply(
                        color: Palette.textSecondaryBaseColor),
                  ),
                  Text(
                    group['description'],
                    textAlign: TextAlign.center,
                    style: bodyTextStyle,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Text(
              '${group['members']} members',
              style: subtitleStyle.apply(color: Palette.textSecondaryBaseColor),
            ),
          )
        ],
      ),
    );
  }
}
