import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/screens/profile/profile_text_card.dart';
import 'package:flutter/material.dart';

class SkillList extends StatelessWidget {
  final List<Skill> skills;
  final double height;
  final bool showDescription;
  final Function onTap;

  SkillList(this.skills,
      {this.height = 100, this.showDescription = true, this.onTap})
      : assert(skills != null);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(0),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: skills.length,
      itemBuilder: (context, index) {
        final skill = skills[index];
        return Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: GestureDetector(
            onTap: () => onTap != null ? onTap(index) : {},
            child: ProfileTextCard(
              height: height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    skill.name + ' - ' + '\$${(skill.price).toString()}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  showDescription ? Text(skill.description) : Container(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
