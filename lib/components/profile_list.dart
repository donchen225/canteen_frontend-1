import 'package:canteen_frontend/components/interest_item.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/screens/profile/profile_section_title.dart';
import 'package:canteen_frontend/screens/profile/skill_list.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class ProfileList extends StatelessWidget {
  final User user;
  final double skillListHeight;
  final EdgeInsetsGeometry padding;
  final bool showName;
  final Key key;
  final Function onTapTeachFunction;
  final Function onTapLearnFunction;

  ProfileList(
    this.user, {
    @required this.skillListHeight,
    this.showName = false,
    this.padding = const EdgeInsets.all(0),
    this.onTapTeachFunction,
    this.onTapLearnFunction,
    this.key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
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
                    bottom: SizeConfig.instance.blockSizeVertical),
                child: ProfilePicture(
                  photoUrl: user.photoUrl,
                  shape: BoxShape.rectangle,
                  editable: false,
                  size: SizeConfig.instance.safeBlockHorizontal * 100,
                ),
              ),
            ],
          ),
          Padding(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Visibility(
                  visible: user.title?.isNotEmpty ?? false,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.instance.blockSizeVertical),
                    child: Text(
                      user.title ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: SizeConfig.instance.blockSizeHorizontal * 4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Visibility(
                    visible: user.interests?.isNotEmpty ?? false,
                    child: Align(
                      alignment: Alignment.center,
                      child: Wrap(
                          children: user.interests
                                  ?.map((x) => Padding(
                                        padding: EdgeInsets.only(
                                            right: SizeConfig.instance
                                                    .blockSizeHorizontal *
                                                3),
                                        child: InterestItem(text: x),
                                      ))
                                  ?.toList() ??
                              []),
                    )),
                ProfileSectionTitle('About'),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.instance.safeBlockVertical,
                  ),
                  child: Text(user.about ?? ''),
                ),
                Visibility(
                  visible: user.teachSkill.length != 0,
                  child: ProfileSectionTitle("My offerings"),
                ),
                SkillList(
                  user.teachSkill,
                  onTapExtraButton: onTapTeachFunction,
                  height: skillListHeight,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
