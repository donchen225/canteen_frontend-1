import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/screens/profile/profile_text_card.dart';
import 'package:canteen_frontend/screens/profile/user_profile_bloc/bloc.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SkillList extends StatefulWidget {
  final List<Skill> skills;
  final double height;
  final bool showDescription;
  final bool selectable;
  final bool selector;
  final Function onTap;

  SkillList(this.skills,
      {this.height = 100,
      this.showDescription = true,
      this.selectable = false,
      this.selector = true,
      this.onTap})
      : assert(skills != null);

  _SkillListState createState() => _SkillListState();
}

class _SkillListState extends State<SkillList> {
  Color backgroundColor = Colors.white;
  Color selectedColor = Colors.red;
  int _selectedIndex;

  Color _getColor(int index) {
    if (widget.selectable) {
      return widget.selector &&
              _selectedIndex != null &&
              _selectedIndex == index
          ? selectedColor
          : backgroundColor;
    }
    return backgroundColor;
  }

  void _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  void _onTapFunction(int index) {
    if (widget.selectable) {
      _onSelected(index);
    }

    if (widget.onTap != null) {
      widget.onTap(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline6;
    final bodyTextStyle = Theme.of(context).textTheme.bodyText2;

    return ListView.builder(
      padding: EdgeInsets.all(0),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.skills.length,
      itemBuilder: (context, index) {
        final skill = widget.skills[index];
        return Container(
          padding: EdgeInsets.only(top: 6, bottom: 6),
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(top: 6, bottom: 6, left: 6, right: 6),
                child: GestureDetector(
                  onTap: () => _onTapFunction(index),
                  child: ProfileTextCard(
                    color: _getColor(index),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              bottom:
                                  SizeConfig.instance.safeBlockVertical / 2),
                          child: Text(
                            skill.name,
                            style: titleStyle,
                          ),
                        ),
                        Visibility(
                          visible: widget.showDescription &&
                              (skill.description?.isNotEmpty ?? false),
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: SizeConfig.instance.safeBlockVertical / 2,
                              bottom: SizeConfig.instance.safeBlockVertical / 2,
                            ),
                            child:
                                Text(skill.description, style: bodyTextStyle),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: SizeConfig.instance.safeBlockVertical / 2),
                          child: Text(
                            '\$${(skill.price).toString()}' +
                                (skill.duration != null
                                    ? ' / ${skill.duration} minutes'
                                    : ''),
                            style: bodyTextStyle.apply(fontWeightDelta: 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => BlocProvider.of<UserProfileBloc>(context)
                      .add(DeleteSkill(skill.type, index)),
                  child: Material(
                    elevation: 1,
                    shape: CircleBorder(),
                    child: Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            width: 1, color: Palette.borderSeparatorColor),
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
