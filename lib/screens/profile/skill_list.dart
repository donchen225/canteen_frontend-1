import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/screens/profile/profile_text_card.dart';
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
              height: widget.height,
              color: _getColor(index),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Text(
                        skill.name +
                            ' - ' +
                            '\$${(skill.price).toString()}' +
                            (skill.duration != null
                                ? ' / ${skill.duration} minutes'
                                : ''),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  widget.showDescription && skill.description.isNotEmpty
                      ? Expanded(
                          child: Container(
                            child: Text(skill.description),
                          ),
                        )
                      : Container(),
                  Visibility(
                    visible: widget.onTapExtraButton != null,
                    child: Expanded(
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            ClipOval(
                              child: Material(
                                color: Colors.orange[400],
                                elevation: 4,
                                child: InkWell(
                                  child: SizedBox(
                                    width: 33,
                                    height: 33,
                                    child: Center(
                                      child: const Icon(
                                        IconData(0xf474,
                                            fontFamily: CupertinoIcons.iconFont,
                                            fontPackage:
                                                CupertinoIcons.iconFontPackage),
                                        size: 25,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    widget.onTapExtraButton(skill);
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
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
