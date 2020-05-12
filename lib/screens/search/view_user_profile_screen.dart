import 'package:canteen_frontend/components/confirmation_dialog.dart';
import 'package:canteen_frontend/components/profile_list.dart';
import 'package:canteen_frontend/models/request/request.dart';
import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/request/request_bloc/bloc.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewUserProfileScreen extends StatelessWidget {
  final User user;

  ViewUserProfileScreen({this.user}) : assert(user != null);

  void _onTapSkillFunction(BuildContext context, Skill skill) {
    showDialog(
      context: context,
      builder: (BuildContext context) => ConfirmationDialog(
        user: user,
        skill: skill,
        onConfirm: (comment) {
          BlocProvider.of<RequestBloc>(context).add(
            AddRequest(
              Request.create(
                skill: skill,
                comment: comment,
                receiverId: user.id,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.displayName ?? ''),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.instance.safeBlockHorizontal * 3,
        ),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: EdgeInsets.only(
                top: SizeConfig.instance.safeBlockVertical * 2,
                bottom: SizeConfig.instance.safeBlockVertical * 6,
              ),
              sliver: ProfileList(
                user,
                skillListHeight: SizeConfig.instance.blockSizeHorizontal * 33,
                onTapTeachFunction: (skill) =>
                    _onTapSkillFunction(context, skill),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
