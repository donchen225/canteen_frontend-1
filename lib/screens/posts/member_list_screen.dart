import 'package:canteen_frontend/components/view_user_profile_screen.dart';
import 'package:canteen_frontend/models/group/group.dart';
import 'package:canteen_frontend/screens/posts/group_list_item.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/shared_blocs/group_home/bloc.dart';
import 'package:canteen_frontend/shared_blocs/profile_bloc/bloc.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MemberListScreen extends StatelessWidget {
  final itemHeight = 100.0;

  @override
  Widget build(BuildContext context) {
    final titleTheme = Theme.of(context).textTheme.subtitle1;

    return BlocBuilder<GroupHomeBloc, GroupHomeState>(
        builder: (BuildContext context, GroupHomeState state) {
      if (state is GroupHomeLoaded) {
        final group = state.group;

        if (group is DetailedGroup) {
          final members = group.memberList;
          return CustomScrollView(
            key: PageStorageKey<String>('members'),
            slivers: <Widget>[
              SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  final member = members[index];

                  return GestureDetector(
                    onTap: () {
                      BlocProvider.of<ProfileBloc>(context)
                          .add(LoadProfile(member.id));
                      Navigator.pushNamed(
                        context,
                        ViewUserProfileScreen.routeName,
                      );
                    },
                    child: Container(
                      height: itemHeight,
                      decoration: BoxDecoration(
                        color: Palette.whiteColor,
                        border: Border(
                          top: BorderSide(
                              color: Palette.borderSeparatorColor, width: 0.25),
                          bottom: BorderSide(
                              color: Palette.borderSeparatorColor, width: 0.25),
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            flex: 2,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: itemHeight * 0.2),
                              child: ProfilePicture(
                                photoUrl: member.photoUrl,
                                size: itemHeight * 0.7,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(member.name,
                                    style:
                                        Theme.of(context).textTheme.headline6),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: itemHeight * 0.03,
                                    bottom: itemHeight * 0.03,
                                  ),
                                  child: Text(
                                    member.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .apply(
                                          color: Palette.textSecondaryBaseColor,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Palette.textSecondaryBaseColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }, childCount: members.length),
              ),
            ],
          );
        }
      }
      return Container();
    });
  }
}
