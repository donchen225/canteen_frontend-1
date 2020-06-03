import 'package:canteen_frontend/models/group/group.dart';
import 'package:canteen_frontend/screens/posts/member_list.dart';
import 'package:canteen_frontend/shared_blocs/group_home/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupHomeMemberListScreen extends StatelessWidget {
  final itemHeight = 100.0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupHomeBloc, GroupHomeState>(
        builder: (BuildContext context, GroupHomeState state) {
      if (state is GroupHomeLoaded) {
        final group = state.group;

        if (group is DetailedGroup) {
          return MemberList(
            memberList: group.memberList,
          );
        }
      }
      return Container();
    });
  }
}
