import 'package:canteen_frontend/models/group/group.dart';
import 'package:canteen_frontend/screens/posts/member_list.dart';
import 'package:canteen_frontend/shared_blocs/group/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupMemberListScreen extends StatelessWidget {
  final itemHeight = 100.0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupBloc, GroupState>(
        builder: (BuildContext context, GroupState state) {
      if (state is GroupLoaded) {
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
