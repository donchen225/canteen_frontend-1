import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_frontend/models/request/request.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/request/request_bloc/bloc.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscoverScreen extends StatelessWidget {
  final List<User> userList;

  DiscoverScreen(this.userList) : assert(userList != null);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final user = userList[index];
              return Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig.instance.blockSizeHorizontal * 3,
                    right: SizeConfig.instance.blockSizeHorizontal * 3,
                    top: SizeConfig.instance.blockSizeHorizontal * 3,
                    bottom: SizeConfig.instance.blockSizeHorizontal * 3),
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
                            height: SizeConfig.instance.blockSizeVertical * 33,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15)),
                              image: DecorationImage(
                                image: (user.photoUrl != null &&
                                        user.photoUrl.isNotEmpty)
                                    ? CachedNetworkImageProvider(user.photoUrl)
                                    : AssetImage(
                                        'assets/blank-profile-picture.jpeg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: SizeConfig
                                              .instance.blockSizeVertical *
                                          3,
                                      bottom:
                                          SizeConfig.instance.blockSizeVertical,
                                      left: SizeConfig
                                              .instance.blockSizeHorizontal *
                                          6),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        user.displayName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 20),
                                      )),
                                ),
                                Visibility(
                                  visible: user.teachSkill.length != 0,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: SizeConfig
                                            .instance.blockSizeVertical,
                                        left: SizeConfig
                                                .instance.blockSizeHorizontal *
                                            6),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('Teaching'),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: user.teachSkill.length != 0,
                                  child: ListView.builder(
                                    padding: EdgeInsets.only(
                                        bottom: SizeConfig
                                            .instance.blockSizeVertical,
                                        left: SizeConfig
                                                .instance.blockSizeHorizontal *
                                            6),
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: user.teachSkill.length,
                                    itemBuilder: (context, index) {
                                      final skill = user.teachSkill[index];
                                      return Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 1),
                                        child: Text(
                                          skill.name +
                                              ' - ' +
                                              '\$${skill.price}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Visibility(
                                  visible: user.learnSkill.length != 0,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: SizeConfig
                                            .instance.blockSizeVertical,
                                        left: SizeConfig
                                                .instance.blockSizeHorizontal *
                                            6),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('Learning'),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: user.learnSkill.length != 0,
                                  child: ListView.builder(
                                    padding: EdgeInsets.only(
                                        bottom: SizeConfig
                                            .instance.blockSizeVertical,
                                        left: SizeConfig
                                                .instance.blockSizeHorizontal *
                                            6),
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: user.learnSkill.length,
                                    itemBuilder: (context, index) {
                                      final skill = user.learnSkill[index];
                                      return Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 1),
                                        child: Text(
                                          skill.name +
                                              ' - ' +
                                              '\$${skill.price}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      bottom: SizeConfig
                                              .instance.blockSizeHorizontal *
                                          3,
                                      right: SizeConfig
                                              .instance.blockSizeHorizontal *
                                          3),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      ClipOval(
                                        child: Material(
                                          color: Colors.orange[400],
                                          elevation: 4,
                                          child: InkWell(
                                            child: SizedBox(
                                              width: SizeConfig.instance
                                                      .blockSizeHorizontal *
                                                  10,
                                              height: SizeConfig.instance
                                                      .blockSizeHorizontal *
                                                  10,
                                              child: Icon(
                                                Icons.send,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                            onTap: () {
                                              // TODO: add animation
                                              BlocProvider.of<RequestBloc>(
                                                      context)
                                                  .add(
                                                AddRequest(
                                                  Request.create(
                                                    receiverId: user.id,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      )
                                    ],
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
      ],
    );
  }
}
