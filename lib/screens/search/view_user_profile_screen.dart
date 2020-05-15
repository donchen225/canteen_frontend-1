import 'package:canteen_frontend/components/confirmation_dialog.dart';
import 'package:canteen_frontend/components/profile_list.dart';
import 'package:canteen_frontend/models/request/request.dart';
import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/request/request_bloc/bloc.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:canteen_frontend/utils/palette.dart';
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
        leading: BackButton(
          onPressed: () {
            BlocProvider.of<SearchBloc>(context).add(SearchShowResults());
          },
        ),
        backgroundColor: Palette.appBarBackgroundColor,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            backgroundColor: Palette.appBarBackgroundColor,
          ),
          SliverPadding(
            padding: EdgeInsets.only(
              bottom: SizeConfig.instance.safeBlockVertical * 6,
            ),
            sliver: ProfileList(
              user,
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.instance.safeBlockHorizontal * 6,
              ),
              skillListHeight: SizeConfig.instance.blockSizeHorizontal * 33,
              onTapTeachFunction: (skill) =>
                  _onTapSkillFunction(context, skill),
            ),
          ),
        ],
      ),
    );
  }
}
