import 'package:canteen_frontend/components/group_picture.dart';
import 'package:canteen_frontend/components/unauthenticated_functions.dart';
import 'package:canteen_frontend/models/group/group.dart';
import 'package:canteen_frontend/models/group/group_repository.dart';
import 'package:canteen_frontend/screens/posts/post_dialog_screen.dart';
import 'package:canteen_frontend/screens/posts/post_list_screen.dart';
import 'package:canteen_frontend/screens/private_group_dialog/access_code_dialog.dart';
import 'package:canteen_frontend/screens/private_group_dialog/bloc/bloc.dart';
import 'package:canteen_frontend/screens/search/group_member_list_screen.dart';
import 'package:canteen_frontend/shared_blocs/authentication/bloc.dart';
import 'package:canteen_frontend/shared_blocs/group/bloc.dart';
import 'package:canteen_frontend/shared_blocs/group_home/group_home_bloc.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewGroupScreen extends StatefulWidget {
  static const routeName = '/group';
  final Group group;

  ViewGroupScreen({Key key, this.group}) : super(key: key);

  @override
  _ViewGroupScreenState createState() => _ViewGroupScreenState();
}

class _ViewGroupScreenState extends State<ViewGroupScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  GroupBloc _groupBloc;
  bool _showFAB = true;
  bool _joined = false;

  final List<String> tabs = [
    'Posts',
    'Members',
  ];

  @override
  void initState() {
    super.initState();

    _groupBloc = BlocProvider.of<GroupBloc>(context);
    _tabController = TabController(vsync: this, length: tabs.length);

    _tabController.addListener(_showFloatingActionButton);
    _tabController.addListener(_loadGroupMembers);

    _joined = BlocProvider.of<GroupHomeBloc>(context)
        .currentUserGroups
        .where((g) => g.id == widget.group.id)
        .isNotEmpty;
  }

  void _showFloatingActionButton() {
    setState(() {
      _showFAB = _tabController.index == 0;
    });
  }

  void _loadGroupMembers() {
    if (_tabController.index == 1) {
      if (!(_groupBloc.currentGroup is DetailedGroup)) {
        _groupBloc.add(LoadGroupMembers(_groupBloc.currentGroup.id));
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authenticated =
        BlocProvider.of<AuthenticationBloc>(context).state is Authenticated;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kAppBarHeight),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              BackButton(
                color: Palette.primaryColor,
              ),
              Container(
                width: kProfileIconSize * 0.5,
              )
            ],
          ),
          backgroundColor: Palette.appBarBackgroundColor,
          elevation: 0,
        ),
      ),
      floatingActionButton: Visibility(
        visible: _showFAB && _joined,
        child: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Palette.primaryColor,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => PostDialogScreen(
                groupId: widget.group.id,
                height: SizeConfig.instance.blockSizeVertical *
                    kDialogScreenHeightBlocks,
              ),
            );
          },
        ),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverToBoxAdapter(
                  child: Container(
                    color: Palette.containerColor,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            top: SizeConfig.instance.safeBlockVertical * 2,
                            left: SizeConfig.instance.safeBlockHorizontal *
                                kHorizontalPaddingBlocks,
                            right: SizeConfig.instance.safeBlockHorizontal *
                                kHorizontalPaddingBlocks,
                          ),
                          child: Column(
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Column(
                                    children: [
                                      GroupPicture(
                                        photoUrl: widget.group.photoUrl,
                                        shape: BoxShape.circle,
                                        size: kProfileSize,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: SizeConfig
                                              .instance.safeBlockVertical,
                                        ),
                                        child: FlatButton(
                                          color: _joined
                                              ? Palette.whiteColor
                                              : Palette.primaryColor,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              color: _joined
                                                  ? Palette.primaryColor
                                                  : Colors.transparent,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Text(
                                            _joined ? 'JOINED' : 'JOIN',
                                            style: Theme.of(context)
                                                .textTheme
                                                .button
                                                .apply(
                                                    color: _joined
                                                        ? Palette.primaryColor
                                                        : Palette.whiteColor,
                                                    fontWeightDelta: 1),
                                          ),
                                          onPressed: () {
                                            if (authenticated) {
                                              if (!(_joined)) {
                                                if (widget.group.type ==
                                                    'public') {
                                                  _groupBloc.add(
                                                      JoinPublicGroup(
                                                          widget.group));
                                                  setState(() {
                                                    _joined = !_joined;
                                                  });
                                                } else {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            dialogContext) =>
                                                        BlocProvider<
                                                            PrivateGroupBloc>(
                                                      create: (dialogContext) =>
                                                          PrivateGroupBloc(
                                                              groupRepository:
                                                                  GroupRepository()),
                                                      child: AccessCodeDialog(
                                                        groupId:
                                                            widget.group.id,
                                                        onSuccess:
                                                            (String groupId) {
                                                          _groupBloc.add(
                                                              JoinedPrivateGroup(
                                                                  widget
                                                                      .group));
                                                          setState(() {
                                                            _joined = !_joined;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                }
                                              }
                                            } else {
                                              UnauthenticatedFunctions
                                                  .showSignUp(context);
                                            }

                                            // TODO: add option to leave group
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.topLeft,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: SizeConfig.instance
                                                  .safeBlockHorizontal *
                                              kHorizontalPaddingBlocks),
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
                                              widget.group.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5
                                                  .apply(fontWeightDelta: 2),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: SizeConfig
                                                  .instance.safeBlockVertical,
                                            ),
                                            child: Text(
                                              widget.group.description ?? '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2,
                                            ),
                                          ),
                                          Text(
                                            '${widget.group.members?.toString() ?? "0"} members' ??
                                                '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .apply(
                                                  color: Palette
                                                      .textSecondaryBaseColor,
                                                ),
                                          ),
                                          // FlatButton(
                                          //   color: _joined
                                          //       ? Palette.whiteColor
                                          //       : Palette.primaryColor,
                                          //   shape: RoundedRectangleBorder(
                                          //     side: BorderSide(
                                          //       color: _joined
                                          //           ? Palette.primaryColor
                                          //           : Colors.transparent,
                                          //       width: 2,
                                          //     ),
                                          //     borderRadius:
                                          //         BorderRadius.circular(30),
                                          //   ),
                                          //   child: Text(
                                          //     _joined ? 'JOINED' : 'JOIN',
                                          //     style: Theme.of(context)
                                          //         .textTheme
                                          //         .button
                                          //         .apply(
                                          //             color: _joined
                                          //                 ? Palette.primaryColor
                                          //                 : Palette.whiteColor,
                                          //             fontWeightDelta: 1),
                                          //   ),
                                          //   onPressed: () {
                                          //     if (authenticated) {
                                          //       if (!(_joined)) {
                                          //         if (widget.group.type ==
                                          //             'public') {
                                          //           _groupBloc.add(
                                          //               JoinPublicGroup(
                                          //                   widget.group));
                                          //           setState(() {
                                          //             _joined = !_joined;
                                          //           });
                                          //         } else {
                                          //           showDialog(
                                          //             context: context,
                                          //             builder: (BuildContext
                                          //                     dialogContext) =>
                                          //                 BlocProvider<
                                          //                     PrivateGroupBloc>(
                                          //               create: (dialogContext) =>
                                          //                   PrivateGroupBloc(
                                          //                       groupRepository:
                                          //                           GroupRepository()),
                                          //               child: AccessCodeDialog(
                                          //                 groupId:
                                          //                     widget.group.id,
                                          //                 onSuccess:
                                          //                     (String groupId) {
                                          //                   _groupBloc.add(
                                          //                       JoinedPrivateGroup(
                                          //                           widget
                                          //                               .group));
                                          //                   setState(() {
                                          //                     _joined =
                                          //                         !_joined;
                                          //                   });
                                          //                 },
                                          //               ),
                                          //             ),
                                          //           );
                                          //         }
                                          //       }
                                          //     } else {
                                          //       UnauthenticatedFunctions
                                          //           .showSignUp(context);
                                          //     }

                                          //     // TODO: add option to leave group
                                          //   },
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(
                                  vertical:
                                      SizeConfig.instance.safeBlockVertical,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      TabBar(
                          indicatorSize: TabBarIndicatorSize.label,
                          controller: _tabController,
                          labelColor: Palette.primaryColor,
                          unselectedLabelColor: Palette.appBarTextColor,
                          labelStyle: Theme.of(context).textTheme.headline6,
                          tabs: tabs
                              .map(
                                (text) => Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: kTabBarTextPadding,
                                  ),
                                  child: Tab(
                                    text: text,
                                  ),
                                ),
                              )
                              .toList()),
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: <Widget>[
                PostListScreen(
                  isHome: false,
                ),
                GroupMemberListScreen(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => kTabBarHeight;
  @override
  double get maxExtent => kTabBarHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: kTabBarHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 0.5,
            color: Palette.borderSeparatorColor,
          ),
        ),
      ),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
