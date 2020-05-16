import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/screens/profile/profile_text_card.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class SkillItem extends StatelessWidget {
  final Skill skill;
  final Function onTap;

  SkillItem({this.skill, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: ProfileTextCard(
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
      ),
    );
  }
}
