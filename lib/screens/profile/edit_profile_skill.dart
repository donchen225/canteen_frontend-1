import 'package:canteen_frontend/components/duration_picker.dart';
import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/models/skill/skill_type.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/profile/user_profile_bloc/bloc.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileSkill extends StatefulWidget {
  final User user;
  final SkillType skillType;
  final int skillIndex;

  EditProfileSkill(
      {@required this.user, @required this.skillType, this.skillIndex});

  _EditProfileSkillState createState() => _EditProfileSkillState();
}

class _EditProfileSkillState extends State<EditProfileSkill> {
  UserProfileBloc _userProfileBloc;
  TextEditingController _skillNameController;
  TextEditingController _skillPriceController;
  TextEditingController _skillDescriptionController;
  final double _titleFontSize = 18;
  Skill skill;

  int _selectedDurationIndex;
  int _initialDurationIndex = 0;
  final double _kPickerSheetHeight = 216.0;
  final List<int> durationOptions = <int>[
    30,
    60,
    90,
    120,
  ];

  @override
  void initState() {
    super.initState();

    _userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    _skillNameController = TextEditingController();
    _skillPriceController = TextEditingController();
    _skillDescriptionController = TextEditingController();

    skill = Skill('', '', 0, 30, widget.skillType);
  }

  @override
  void dispose() {
    _skillNameController.dispose();
    _skillPriceController.dispose();
    _skillDescriptionController.dispose();
    super.dispose();
  }

  Widget _buildDurationPicker(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) {
            return DurationPicker(
              durationOptions: durationOptions,
              onChanged: (index) {
                setState(() {
                  _selectedDurationIndex = index;
                });
              },
            );
          },
        );
      },
      child: _buildMenu(
        Text(
          '${durationOptions[_selectedDurationIndex ?? _initialDurationIndex]} minutes',
        ),
      ),
    );
  }

  Widget _buildMenu(Widget child) {
    return Container(
      width: SizeConfig.instance.blockSizeHorizontal * 33,
      height: SizeConfig.instance.safeBlockVertical * 7,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey[400]),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: SafeArea(
            top: false,
            bottom: false,
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final skillList = widget.skillType == SkillType.teach
        ? widget.user.teachSkill
        : widget.user.learnSkill;

    if (widget.skillIndex < skillList.length) {
      skill = skillList[widget.skillIndex];
    }

    _skillNameController.text = skill.name;
    _skillPriceController.text = skill.price.toString();
    _skillDescriptionController.text = skill.description;
    _initialDurationIndex = durationOptions.indexOf(skill.duration);
    _initialDurationIndex =
        _initialDurationIndex != -1 ? _initialDurationIndex : 0;

    return Scaffold(
      backgroundColor: Palette.containerColor,
      appBar: AppBar(
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
        backgroundColor: Palette.appBarBackgroundColor,
        elevation: 1,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                _userProfileBloc.add(LoadUserProfile(widget.user));
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 14,
                  color: Palette.orangeColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(widget.skillType == SkillType.teach
                ? 'Edit Teach Skill'
                : 'Edit Learn Skill'),
            GestureDetector(
              onTap: () {
                final price = int.parse(_skillPriceController.text);
                final duration = durationOptions[
                    _selectedDurationIndex ?? _initialDurationIndex];

                if (skill.name != _skillNameController.text ||
                    skill.price != price ||
                    skill.description != _skillDescriptionController.text ||
                    skill.duration != duration) {
                  print('UPDATING SKILL');
                  _userProfileBloc.add(UpdateSkill(
                      widget.user,
                      Skill(
                          _skillNameController.text,
                          _skillDescriptionController.text,
                          price,
                          duration,
                          widget.skillType),
                      widget.skillType,
                      widget.skillIndex ?? 0));
                } else {
                  print('NOT UPDATING SKILL');
                  _userProfileBloc.add(LoadUserProfile(widget.user));
                }
              },
              child: Text(
                'Done',
                style: TextStyle(
                  fontSize: 14,
                  color: Palette.orangeColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(
          left: SizeConfig.instance.blockSizeHorizontal * 6,
          right: SizeConfig.instance.blockSizeHorizontal * 6,
          top: SizeConfig.instance.blockSizeHorizontal * 6,
          bottom: SizeConfig.instance.blockSizeVertical * 6,
        ),
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                left: SizeConfig.instance.safeBlockHorizontal,
                right: SizeConfig.instance.safeBlockHorizontal,
                bottom: SizeConfig.instance.safeBlockVertical),
            alignment: Alignment.centerLeft,
            child:
                Text('Skill Name', style: TextStyle(fontSize: _titleFontSize)),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
            margin: EdgeInsets.only(
                bottom: SizeConfig.instance.blockSizeVertical * 3),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey[400]),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: _skillNameController,
              textCapitalization: TextCapitalization.sentences,
              autofocus: true,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  decoration: TextDecoration.none),
              decoration: InputDecoration(border: InputBorder.none),
              keyboardType: TextInputType.multiline,
              maxLength:
                  100, // TODO: move character counter to bottom right corner of container
              maxLines: null,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                bottom: SizeConfig.instance.blockSizeVertical * 3),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                left: SizeConfig.instance.safeBlockHorizontal,
                                right: SizeConfig.instance.safeBlockHorizontal,
                                bottom: SizeConfig.instance.safeBlockVertical),
                            child: Text(
                              'Price',
                              style: TextStyle(fontSize: _titleFontSize),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            height: SizeConfig.instance.safeBlockVertical * 7,
                            width: SizeConfig.instance.safeBlockHorizontal * 20,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: Colors.grey[400]),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: TextField(
                                textAlign: TextAlign.center,
                                controller: _skillPriceController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                autofocus: true,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    decoration: TextDecoration.none),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  counterText: "",
                                  contentPadding: EdgeInsets.all(0),
                                  isDense: true,
                                ),
                                keyboardType: TextInputType.number,
                                maxLines: 1,
                                minLines: 1,
                                maxLength: 5,
                              ),
                            ),
                          ),
                        ],
                      )),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                left: SizeConfig.instance.safeBlockHorizontal,
                                right: SizeConfig.instance.safeBlockHorizontal,
                                bottom: SizeConfig.instance.safeBlockVertical),
                            child: Text(
                              'Duration',
                              style: TextStyle(fontSize: _titleFontSize),
                            ),
                          ),
                          _buildDurationPicker(context),
                        ],
                      )),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: SizeConfig.instance.safeBlockVertical),
                  child: Text(
                      'Note: Setting the price to \$0 will enable others to connect with you without paying.'),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: SizeConfig.instance.safeBlockHorizontal,
                right: SizeConfig.instance.safeBlockHorizontal,
                bottom: SizeConfig.instance.safeBlockVertical),
            child: Text('Skill Description',
                style: TextStyle(fontSize: _titleFontSize)),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            padding: EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 5),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey[400]),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: _skillDescriptionController,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  decoration: TextDecoration.none),
              decoration: InputDecoration(border: InputBorder.none),
              keyboardType: TextInputType.multiline,
              maxLength:
                  150, // TODO: move character counter to bottom right corner of container
              maxLines: null,
            ),
          ),
        ],
      ),
    );
  }
}
