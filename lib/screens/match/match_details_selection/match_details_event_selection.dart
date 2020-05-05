import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/models/match/match.dart';
import 'package:canteen_frontend/models/video_chat_date/video_chat_date.dart';
import 'package:canteen_frontend/screens/match/match_detail_bloc/bloc.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/utils/size_config.dart';
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
                      top: SizeConfig.instance.blockSizeVertical,
                      bottom: SizeConfig.instance.blockSizeVertical,
                      left: SizeConfig.instance.blockSizeHorizontal * 3,
                      right: SizeConfig.instance.blockSizeHorizontal * 3,
                    ),
                    decoration: BoxDecoration(
                      color: selected[i] ? Colors.blue : Colors.transparent,
                      border: Border.all(
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  skill.name,
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text('${skill.duration.toString()} min'),
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
                  bottom: SizeConfig.instance.blockSizeVertical),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: RaisedButton(
                  child: Text('Continue'),
                  onPressed: _selectedSkill != null
                      ? () {
                          BlocProvider.of<MatchDetailBloc>(context)
                              .add(SelectEvent(_selectedSkill));
                        }
                      : null,
                ),
              ),
            ],
          )
        ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: SizeConfig.instance.blockSizeVertical * 3,
        bottom: SizeConfig.instance.blockSizeVertical * 3,
        left: SizeConfig.instance.blockSizeHorizontal * 3,
        right: SizeConfig.instance.blockSizeHorizontal * 3,
      ),
      child: ListView(
        children: _buildWidgetList(),
      ),
    );
  }
}
