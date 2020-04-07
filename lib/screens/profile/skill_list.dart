import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/screens/profile/profile_text_card.dart';
import 'package:flutter/material.dart';

class SkillList extends StatelessWidget {
  final List<Skill> skills;
  final Function onTap;

  SkillList(this.skills, {this.onTap}) : assert(skills != null);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: skills.length,
      itemBuilder: (context, index) {
        final skill = skills[index];
        return Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: GestureDetector(
            onTap: () {
              onTap(index);
            },
            child: ProfileTextCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    skill.name + ' - ' + '\$${(skill.price).toString()}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(skill.description),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
