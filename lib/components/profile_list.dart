import 'package:canteen_frontend/components/interest_item.dart';
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
                  editable: false,
                  size: SizeConfig.instance.blockSizeHorizontal * 50,
                ),
              ),
            ],
          ),
          Visibility(
            visible: user.title?.isNotEmpty ?? false,
            child: Container(
              child: Text(
                user.title ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: SizeConfig.instance.blockSizeHorizontal * 4,
                ),
              ),
            ),
          ),
          Visibility(
              visible: user.interests.isNotEmpty,
              child: Align(
                alignment: Alignment.center,
                child: Wrap(
                    children: user.interests
                        .map((x) => Padding(
                              padding: EdgeInsets.only(
                                  right:
                                      SizeConfig.instance.blockSizeHorizontal *
                                          3),
                              child: InterestItem(text: x),
                            ))
                        .toList()),
              )),
          ProfileSectionTitle('About'),
          ProfileTextCard(
            child: Container(
              child: Text(user.about ?? ''),
            ),
          ),
          Visibility(
            visible: user.teachSkill.length != 0,
            child: ProfileSectionTitle("My offerings"),
          ),
          SkillList(
            user.teachSkill,
            onTapExtraButton: onTapTeachFunction,
            height: height,
          ),
        ],
      ),
    );
  }
}
