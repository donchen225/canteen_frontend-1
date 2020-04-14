import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/screens/profile/profile_section_title.dart';
import 'package:canteen_frontend/screens/profile/profile_text_card.dart';
import 'package:canteen_frontend/screens/profile/skill_list.dart';
import 'package:flutter/material.dart';

class ProfileList extends StatelessWidget {
  final User user;
  final double height;
  final bool showName;

  ProfileList(this.user, {@required this.height, this.showName = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: ListView(
          children: <Widget>[
            Visibility(
              visible: showName,
              child: Center(
                  child: Text(
                user.displayName ?? '',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: ProfilePicture(
                    photoUrl: user.photoUrl,
                    localPicture:
                        AssetImage('assets/blank-profile-picture.jpeg'),
                    editable: false,
                    size: 160,
                  ),
                ),
              ],
            ),
            ProfileSectionTitle('About'),
            ProfileTextCard(
              child: Container(
                height: height,
                child: Text(user.about ?? ''),
              ),
            ),
            ProfileSectionTitle("I'm teaching"),
            SkillList(
              user.teachSkill,
            ),
            ProfileSectionTitle("I'm learning"),
            SkillList(
              user.learnSkill,
            ),
          ],
        ),
      ),
    );
  }
}
