import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class SkillItem extends StatelessWidget {
  final double verticalPadding;
  final double horizontalPadding;
  final Skill skill;
  final bool showButton;
  final Function onTap;

  SkillItem(
      {this.verticalPadding = 0,
      this.horizontalPadding = 0,
      this.skill,
      this.showButton = true,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline6;
    final bodyTextStyle = Theme.of(context).textTheme.bodyText2;

    return Container(
      padding: EdgeInsets.only(
        top: verticalPadding,
        bottom: verticalPadding,
        left: horizontalPadding,
        right: horizontalPadding,
      ),
      decoration: BoxDecoration(
          color: Palette.containerColor,
          border: Border(
              bottom: BorderSide(
            width: 0.5,
            color: Palette.borderSeparatorColor,
          ))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: Text(
              skill.name,
              style: titleStyle,
            ),
          ),
          Visibility(
            visible: skill.description?.isNotEmpty ?? false,
            child: Padding(
              padding: EdgeInsets.only(
                top: SizeConfig.instance.safeBlockVertical,
                bottom: SizeConfig.instance.safeBlockVertical,
              ),
              child: Text(skill.description, style: bodyTextStyle),
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '\$${(skill.price).toString()}' +
                      (skill.duration != null
                          ? ' / ${skill.duration} minutes'
                          : ''),
                  style: bodyTextStyle.apply(fontWeightDelta: 1),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
