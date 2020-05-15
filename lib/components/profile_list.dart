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
  final Key key;
  final Function onTapTeachFunction;
  final Function onTapLearnFunction;

  ProfileList(
    this.user, {
    @required this.skillListHeight,
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
          Padding(
            padding: EdgeInsets.only(
              left: SizeConfig.instance.safeBlockHorizontal * 6,
              right: SizeConfig.instance.safeBlockHorizontal * 6,
              bottom: SizeConfig.instance.safeBlockVertical * 2,
            ),
            child: Container(
              height: SizeConfig.instance.safeBlockHorizontal * 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ProfilePicture(
                    photoUrl: user.photoUrl,
                    shape: BoxShape.circle,
                    editable: false,
                    size: SizeConfig.instance.safeBlockHorizontal * 30,
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              SizeConfig.instance.safeBlockHorizontal * 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                              bottom:
                                  SizeConfig.instance.safeBlockVertical * 0.5,
                            ),
                            child: Text(
                              user.displayName,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .apply(fontWeightDelta: 2),
                            ),
                          ),
                          Text(
                            user.title ?? '',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
