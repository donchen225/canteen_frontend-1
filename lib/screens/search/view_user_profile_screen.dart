import 'package:canteen_frontend/components/confirmation_dialog.dart';
import 'package:canteen_frontend/components/interest_item.dart';
import 'package:canteen_frontend/components/profile_list.dart';
import 'package:canteen_frontend/models/request/request.dart';
import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/screens/profile/skill_item.dart';
import 'package:canteen_frontend/screens/request/request_bloc/bloc.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewUserProfileScreen extends StatefulWidget {
  final User user;
  final Function onTapBack;

  ViewUserProfileScreen({this.user, this.onTapBack}) : assert(user != null);

  @override
  _ViewUserProfileScreenState createState() => _ViewUserProfileScreenState();
}

class _ViewUserProfileScreenState extends State<ViewUserProfileScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  final List<String> tabs = [
    'OFFERINGS',
    'DETAILS',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTapSkillFunction(BuildContext context, Skill skill) {
    showDialog(
      context: context,
      builder: (BuildContext context) => ConfirmationDialog(
        user: widget.user,
        skill: skill,
        onConfirm: (comment) {
          BlocProvider.of<RequestBloc>(context).add(
            AddRequest(
              Request.create(
                skill: skill,
                comment: comment,
                receiverId: widget.user.id,
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
      backgroundColor: Palette.containerColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          // These are the slivers that show up in the "outer" scroll view.
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                leading: Container(
                  color: Colors.red,
                  child: BackButton(
                    onPressed: () {
                      if (widget.onTapBack != null) {
                        widget.onTapBack();
                      }
                    },
                  ),
                ),
                title: Row(
                  children: <Widget>[
                    Expanded(
                        child: Container(
                            height: kToolbarHeight,
                            color: Colors.red,
                            child: Text('Test'))),
                  ],
                ),
                elevation: 0,
                primary: true,
                backgroundColor: Palette.appBarBackgroundColor,
                pinned: true,
                // forceElevated: innerBoxIsScrolled,
                expandedHeight: SizeConfig.instance.safeBlockVertical * 45,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: SafeArea(
                    top: true,
                    child: Container(
                      height: SizeConfig.instance.safeBlockVertical * 35,
                      padding: EdgeInsets.only(
                        top: kToolbarHeight,
                        bottom: kToolbarHeight,
                        left: SizeConfig.instance.safeBlockHorizontal * 6,
                        right: SizeConfig.instance.safeBlockHorizontal * 6,
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            height:
                                SizeConfig.instance.safeBlockHorizontal * 30,
                            padding: EdgeInsets.only(
                              bottom: SizeConfig.instance.safeBlockVertical,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                ProfilePicture(
                                  photoUrl: widget.user.photoUrl,
                                  shape: BoxShape.circle,
                                  editable: false,
                                  size:
                                      SizeConfig.instance.safeBlockHorizontal *
                                          30,
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: SizeConfig
                                                .instance.safeBlockHorizontal *
                                            6),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                            bottom: SizeConfig.instance
                                                    .safeBlockVertical *
                                                0.5,
                                          ),
                                          child: Text(
                                            widget.user.displayName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .apply(fontWeightDelta: 2),
                                          ),
                                        ),
                                        Text(
                                          widget.user.title ?? '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.instance.safeBlockVertical,
                            ),
                            child: Text(widget.user.about ?? ''),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Wrap(
                                children: widget.user.interests
                                        ?.map((x) => Padding(
                                              padding: EdgeInsets.only(
                                                  right: SizeConfig.instance
                                                          .blockSizeHorizontal *
                                                      3),
                                              child: InterestItem(text: x),
                                            ))
                                        ?.toList() ??
                                    []),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                bottom: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.label,
                  // These are the widgets to put in each tab in the tab bar.
                  tabs: tabs
                      .map((String name) => Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: kTabBarTextPadding,
                            ),
                            child: Tab(text: name),
                          ))
                      .toList(),
                ),
              ),
            ),

            // Padding(
            //   padding: EdgeInsets.only(
            //     left: SizeConfig.instance.safeBlockHorizontal * 6,
            //     right: SizeConfig.instance.safeBlockHorizontal * 6,
            //   ),
            //   child: Column(
            //     children: <Widget>[
            //       Container(
            //         height: SizeConfig.instance.safeBlockHorizontal * 30,
            //         padding: EdgeInsets.only(
            //           bottom: SizeConfig.instance.safeBlockVertical,
            //         ),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           children: <Widget>[
            //             ProfilePicture(
            //               photoUrl: widget.user.photoUrl,
            //               shape: BoxShape.circle,
            //               editable: false,
            //               size: SizeConfig.instance.safeBlockHorizontal * 30,
            //             ),
            //             Expanded(
            //               child: Container(
            //                 alignment: Alignment.topLeft,
            //                 padding: EdgeInsets.symmetric(
            //                     horizontal:
            //                         SizeConfig.instance.safeBlockHorizontal *
            //                             6),
            //                 child: Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: <Widget>[
            //                     Padding(
            //                       padding: EdgeInsets.only(
            //                         bottom:
            //                             SizeConfig.instance.safeBlockVertical *
            //                                 0.5,
            //                       ),
            //                       child: Text(
            //                         widget.user.displayName,
            //                         style: Theme.of(context)
            //                             .textTheme
            //                             .headline6
            //                             .apply(fontWeightDelta: 2),
            //                       ),
            //                     ),
            //                     Text(
            //                       widget.user.title ?? '',
            //                       style: Theme.of(context).textTheme.bodyText1,
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //       Container(
            //         padding: EdgeInsets.symmetric(
            //           vertical: SizeConfig.instance.safeBlockVertical,
            //         ),
            //         child: Text(widget.user.about ?? ''),
            //       ),
            //       Align(
            //         alignment: Alignment.centerLeft,
            //         child: Wrap(
            //             children: widget.user.interests
            //                     ?.map((x) => Padding(
            //                           padding: EdgeInsets.only(
            //                               right: SizeConfig.instance
            //                                       .blockSizeHorizontal *
            //                                   3),
            //                           child: InterestItem(text: x),
            //                         ))
            //                     ?.toList() ??
            //                 []),
            //       ),
            //     ],
            //   ),
            // ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: tabs.map((String name) {
            return SafeArea(
              top: false,
              bottom: false,
              child: Builder(
                builder: (BuildContext context) {
                  return CustomScrollView(
                    key: PageStorageKey<String>(name),
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(8.0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              final skill = widget.user.teachSkill[index];

                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 0),
                                child: SkillItem(
                                  skill: skill,
                                  onTap: () =>
                                      _onTapSkillFunction(context, skill),
                                ),
                              );
                            },
                            childCount: widget.user.teachSkill.length,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
