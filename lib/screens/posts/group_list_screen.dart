import 'package:canteen_frontend/screens/posts/group_list_item.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class MemberListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final titleTheme = Theme.of(context).textTheme.subtitle1;

    final members = [];

    return Scaffold(
      body: CustomScrollView(
        key: PageStorageKey<String>('members'),
        slivers: <Widget>[
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {})),
        ],
      ),
    );
  }
}
