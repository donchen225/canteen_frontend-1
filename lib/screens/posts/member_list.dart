import 'package:canteen_frontend/models/group/group_member.dart';
import 'package:canteen_frontend/screens/posts/member_item.dart';
import 'package:flutter/material.dart';

class MemberList extends StatelessWidget {
  final List<GroupMember> memberList;
  final itemHeight = 100.0;

  MemberList({@required this.memberList});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: PageStorageKey<String>('members'),
      slivers: <Widget>[
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            final member = memberList[index];

            return MemberItem(member: member, itemHeight: itemHeight);
          }, childCount: memberList.length),
        ),
      ],
    );
  }
}
