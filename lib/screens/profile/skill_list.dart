import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/screens/profile/profile_text_card.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SkillList extends StatefulWidget {
  final List<Skill> skills;
  final double height;
  final bool showDescription;
  final bool selectable;
  final bool selector;
  final Function onTap;
  final Function onTapExtraButton;

  SkillList(this.skills,
      {this.height = 100,
      this.showDescription = true,
      this.selectable = false,
      this.selector = true,
      this.onTap,
      this.onTapExtraButton})
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
    return ListView.builder(
      padding: EdgeInsets.all(0),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.skills.length,
      itemBuilder: (context, index) {
        final skill = widget.skills[index];
        return Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: GestureDetector(
            onTap: () => _onTapFunction(index),
            child: ProfileTextCard(
              color: _getColor(index),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: Text(
                      skill.name,
                      style: TextStyle(
                          fontSize:
                              SizeConfig.instance.blockSizeHorizontal * 4 * 1.2,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  widget.showDescription && skill.description.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.only(
                              top: SizeConfig.instance.blockSizeVertical),
                          child: Text(skill.description),
                        )
                      : Container(),
                  Visibility(
                    visible: widget.onTapExtraButton != null,
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
                            color: Palette.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              'Connect',
                              style: Theme.of(context).textTheme.button.apply(
                                    color: Palette.buttonDarkTextColor,
                                  ),
                            ),
                            onPressed: () => widget.onTapExtraButton(skill),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
