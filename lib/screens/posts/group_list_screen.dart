import 'package:canteen_frontend/screens/posts/group_list_item.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class GroupListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final titleTheme = Theme.of(context).textTheme.subtitle1;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  // onTap: () {
                  //   BlocProvider.of<PostScreenBloc>(context)
                  //       .add(DiscoverGroups());
                  // },
                  child: GroupListItem(
                    child: Text('Discover groups',
                        style: titleTheme.apply(
                          fontWeightDelta: 2,
                        )),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    right: SizeConfig.instance.safeBlockHorizontal *
                        kHorizontalPaddingBlocks,
                    left: SizeConfig.instance.safeBlockHorizontal *
                        kHorizontalPaddingBlocks,
                    top: SizeConfig.instance.safeBlockVertical,
                    bottom: SizeConfig.instance.safeBlockVertical,
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text('My Groups'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
