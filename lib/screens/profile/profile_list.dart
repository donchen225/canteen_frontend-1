import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/screens/profile/profile_section_title.dart';
import 'package:canteen_frontend/screens/profile/profile_text_card.dart';
import 'package:canteen_frontend/screens/profile/skill_list.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class ProfileList extends StatelessWidget {
  final User user;
  final double height;
  final bool showName;
  final Key key;
  final Function onTapTeachFunction;
  final Function onTapLearnFunction;

  ProfileList(this.user,
      {@required this.height,
      this.showName = false,
      this.onTapTeachFunction,
      this.onTapLearnFunction,
      this.key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate.fixed(
        [
          Visibility(
            visible: showName,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.instance.blockSizeVertical * 3,
              ),
              child: Center(
                  child: Text(
                user.displayName ?? '',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              )),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    bottom: SizeConfig.instance.blockSizeVertical * 3),
                child: ProfilePicture(
                  photoUrl: user.photoUrl,
                  localPicture: AssetImage('assets/blank-profile-picture.jpeg'),
                  editable: false,
                  size: SizeConfig.instance.blockSizeHorizontal * 50,
                ),
              ),
            ],
          ),
          ProfileSectionTitle('About'),
          ProfileTextCard(
            height: height,
            child: Container(
              child: Text(user.about ?? ''),
            ),
          ),
          ProfileSectionTitle("I'm teaching"),
          SkillList(
            user.teachSkill,
            onTapExtraButton: onTapTeachFunction,
            height: height,
          ),
          ProfileSectionTitle("I'm learning"),
          SkillList(
            user.learnSkill,
            onTapExtraButton: onTapLearnFunction,
            height: height,
          ),
        ],
      ),
    );
  }
}
