import 'package:canteen_frontend/models/skill/skill.dart';
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
            child: Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey[200]),
                borderRadius: BorderRadius.circular(6),
              ),
              margin: EdgeInsets.all(0),
              elevation: 0.3,
              color: Colors.white,
              child: Container(
                height: 100,
                padding: EdgeInsets.all(15),
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
          ),
        );
      },
    );
  }
}
