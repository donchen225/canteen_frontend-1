import 'package:canteen_frontend/components/view_user_profile_screen.dart';
import 'package:canteen_frontend/models/group/group_member.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/shared_blocs/profile_bloc/bloc.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                        padding:
                            EdgeInsets.symmetric(horizontal: itemHeight * 0.2),
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
                              style: Theme.of(context).textTheme.headline6),
                          Padding(
                            padding: EdgeInsets.only(
                              top: itemHeight * 0.03,
                              bottom: itemHeight * 0.03,
                            ),
                            child: Text(
                              member.title,
                              style:
                                  Theme.of(context).textTheme.bodyText2.apply(
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
          }, childCount: memberList.length),
        ),
      ],
    );
  }
}
