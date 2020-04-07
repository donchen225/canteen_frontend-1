import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/profile/user_profile_bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileSkill extends StatefulWidget {
  final User user;
  final String skillType;
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

  @override
  void initState() {
    super.initState();

    _userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    _skillNameController = TextEditingController();
    _skillPriceController = TextEditingController();
    _skillDescriptionController = TextEditingController();

    skill = Skill('', '', 0);
  }

  @override
  Widget build(BuildContext context) {
    final skillList = widget.skillType == 'teach'
        ? widget.user.teachSkill
        : widget.user.learnSkill;

    if (widget.skillIndex < skillList.length) {
      skill = skillList[widget.skillIndex];
    }

    _skillNameController.text = skill.name;
    _skillPriceController.text = skill.price.toString();
    _skillDescriptionController.text = skill.description;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                style: TextStyle(fontSize: 14),
              ),
            ),
            Text(widget.skillType == 'teach'
                ? 'Edit Teach Skill'
                : 'Edit Learn Skill'),
            GestureDetector(
              onTap: () {
                final price = int.parse(_skillPriceController.text);

                if (skill.name != _skillNameController.text ||
                    skill.price != price ||
                    skill.description != _skillDescriptionController.text) {
                  print('UPDATING SKILL');
                  _userProfileBloc.add(UpdateSkill(
                      widget.user,
                      Skill(_skillNameController.text,
                          _skillDescriptionController.text, price),
                      widget.skillType,
                      widget.skillIndex ?? 0));
                } else {
                  print('NOT UPDATING SKILL');
                  _userProfileBloc.add(LoadUserProfile(widget.user));
                }
              },
              child: Text(
                'Done',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 10, bottom: 10),
              alignment: Alignment.centerLeft,
              child: Text('Skill Name',
                  style: TextStyle(fontSize: _titleFontSize)),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey[400]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _skillNameController,
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
              padding: EdgeInsets.only(left: 10, bottom: 10),
              alignment: Alignment.centerLeft,
              child: Text('Price', style: TextStyle(fontSize: _titleFontSize)),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey[400]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _skillPriceController,
                autofocus: true,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    decoration: TextDecoration.none),
                decoration: InputDecoration(border: InputBorder.none),
                keyboardType: TextInputType.number,
                maxLines: null,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, bottom: 10),
              alignment: Alignment.centerLeft,
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
      ),
    );
  }
}
