import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/models/match/match.dart';
import 'package:canteen_frontend/screens/match/match_detail_bloc/bloc.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchDetailEventSelectionScreen extends StatefulWidget {
  final User user;
  final Match match;

  MatchDetailEventSelectionScreen({
    @required this.user,
    @required this.match,
  });

  @override
  _MatchDetailEventSelectionScreenState createState() =>
      _MatchDetailEventSelectionScreenState();
}

class _MatchDetailEventSelectionScreenState
    extends State<MatchDetailEventSelectionScreen> {
  Map<int, Skill> offeringList;
  List<bool> selected;
  Map<int, bool> _selectedReset;
  Skill _selectedSkill;

  _MatchDetailEventSelectionScreenState();

  @override
  void initState() {
    super.initState();

    offeringList = widget.user.teachSkill?.asMap() ?? {};
    selected = List<bool>.generate(offeringList.keys.length, (i) => false);
    _selectedReset =
        List<bool>.generate(offeringList.keys.length, (i) => false).asMap();
  }

  List<Widget> _buildOfferingWidgets() {
    return offeringList
        .map((i, skill) {
          return MapEntry<int, Widget>(
              i,
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.instance.blockSizeVertical),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedReset.forEach((index, value) {
                        if (index != i) {
                          selected[index] = value;
                        }
                      });
                      selected[i] = !selected[i];
                      _selectedSkill = selected[i] ? offeringList[i] : null;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      top: SizeConfig.instance.blockSizeVertical * 2,
                      bottom: SizeConfig.instance.blockSizeVertical * 2,
                      left: SizeConfig.instance.blockSizeHorizontal * 4,
                      right: SizeConfig.instance.blockSizeHorizontal * 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: selected[i] ? Palette.orangeColor : Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: SizeConfig
                                              .instance.blockSizeVertical /
                                          2),
                                  child: Text(
                                    skill.name,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: SizeConfig
                                              .instance.blockSizeHorizontal,
                                          top: SizeConfig
                                                  .instance.blockSizeVertical /
                                              2,
                                          bottom: SizeConfig
                                                  .instance.blockSizeVertical /
                                              2),
                                      child: const Icon(IconData(0xf26e,
                                          fontFamily: CupertinoIcons.iconFont,
                                          fontPackage:
                                              CupertinoIcons.iconFontPackage)),
                                    ),
                                    Text('${skill.duration.toString()} min'),
                                  ],
                                ),
                                Text(skill.description)
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                '\$' + skill.price.toString(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
        })
        .values
        .toList();
  }

  List<Widget> _buildWidgetList() {
    return <Widget>[
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(
                  top: SizeConfig.instance.blockSizeVertical * 6,
                  bottom: SizeConfig.instance.blockSizeVertical * 3),
              child: ProfilePicture(
                photoUrl: widget.user.photoUrl,
                editable: false,
                size: SizeConfig.instance.blockSizeHorizontal * 40,
              ),
            ),
          ),
        ] +
        _buildOfferingWidgets() +
        <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.instance.blockSizeVertical * 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: RaisedButton(
                    padding: EdgeInsets.only(
                      top: SizeConfig.instance.blockSizeVertical * 2,
                      bottom: SizeConfig.instance.blockSizeVertical * 2,
                      left: SizeConfig.instance.blockSizeHorizontal * 6,
                      right: SizeConfig.instance.blockSizeHorizontal * 6,
                    ),
                    color: Palette.orangeColor,
                    disabledColor: Palette.disabledButtonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 1,
                    child: Text(
                      'Continue',
                      style: TextStyle(
                          fontSize: 16,
                          color: Palette.whiteColor,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: _selectedSkill != null
                        ? () {
                            BlocProvider.of<MatchDetailBloc>(context)
                                .add(SelectEvent(_selectedSkill));
                          }
                        : null,
                  ),
                ),
              ],
            ),
          )
        ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: SizeConfig.instance.blockSizeHorizontal * 3,
        right: SizeConfig.instance.blockSizeHorizontal * 3,
      ),
      child: ListView(
        children: _buildWidgetList(),
      ),
    );
  }
}
