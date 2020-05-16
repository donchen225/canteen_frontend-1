import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class SkillItem extends StatelessWidget {
  final double verticalPadding;
  final double horizontalPadding;
  final Skill skill;
  final Function onTap;

  SkillItem(
      {this.verticalPadding = 0,
      this.horizontalPadding = 0,
      this.skill,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: verticalPadding,
        bottom: verticalPadding,
        left: horizontalPadding,
        right: horizontalPadding,
      ),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        width: 0.5,
        color: Colors.grey[400],
      ))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: Text(
              skill.name,
              style: TextStyle(
                  fontSize: SizeConfig.instance.blockSizeHorizontal * 4 * 1.2,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: SizeConfig.instance.blockSizeVertical),
            child: Text(skill.description),
          ),
          Visibility(
            visible: onTap != null,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '\$${(skill.price).toString()}' +
                        (skill.duration != null
                            ? ' / ${skill.duration} minutes'
                            : ''),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  FlatButton(
                    color: Palette.orangeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'Connect',
                      style: Theme.of(context).textTheme.button.apply(
                            color: Palette.buttonDarkTextColor,
                          ),
                    ),
                    onPressed: () => onTap(skill),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
