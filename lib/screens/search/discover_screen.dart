import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscoverScreen extends StatelessWidget {
  final List<User> userList;

  DiscoverScreen(this.userList) : assert(userList != null);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverPadding(
          padding: EdgeInsets.only(top: SizeConfig.instance.safeBlockVertical),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final user = userList[index];
                return Padding(
                  padding: EdgeInsets.only(
                      left: SizeConfig.instance.safeBlockHorizontal * 3,
                      right: SizeConfig.instance.safeBlockHorizontal * 3,
                      bottom: SizeConfig.instance.safeBlockVertical),
                  child: GestureDetector(
                    onTap: () {
                      BlocProvider.of<SearchBloc>(context)
                          .add(SearchInspectUser(user));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              height:
                                  SizeConfig.instance.blockSizeVertical * 33,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15)),
                                image: DecorationImage(
                                  image: (user.photoUrl != null &&
                                          user.photoUrl.isNotEmpty)
                                      ? CachedNetworkImageProvider(
                                          user.photoUrl)
                                      : AssetImage(
                                          'assets/blank-profile-picture.jpeg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                top: SizeConfig.instance.safeBlockVertical * 2,
                                bottom:
                                    SizeConfig.instance.safeBlockVertical * 2,
                                left:
                                    SizeConfig.instance.safeBlockHorizontal * 6,
                                right:
                                    SizeConfig.instance.safeBlockHorizontal * 6,
                              ),
                              child: Column(
                                children: <Widget>[
                                  Visibility(
                                    visible: user.title?.isNotEmpty ?? false,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: SizeConfig
                                              .instance.safeBlockVertical),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(user.title ?? '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: user.teachSkill.length != 0,
                                    child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: user.teachSkill.length,
                                      itemBuilder: (context, index) {
                                        final skill = user.teachSkill[index];
                                        return Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 1),
                                          child: Text(
                                            skill.name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              childCount: userList.length,
            ),
          ),
        ),
      ],
    );
  }
}
