import 'package:canteen_frontend/components/confirmation_dialog_screen.dart';
import 'package:canteen_frontend/components/interest_item.dart';
import 'package:canteen_frontend/models/request/request.dart';
import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/models/user/firebase_user_repository.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/screens/profile/skill_item.dart';
import 'package:canteen_frontend/screens/profile/user_profile_screen.dart';
import 'package:canteen_frontend/screens/request/request_bloc/bloc.dart';
import 'package:canteen_frontend/shared_blocs/profile_bloc/bloc.dart';
import 'package:canteen_frontend/shared_blocs/user/user_bloc.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewUserProfileScreen extends StatefulWidget {
  final User user;
  final bool editable;
  static const routeName = '/user';

  ViewUserProfileScreen({this.user, this.editable = false});

  @override
  _ViewUserProfileScreenState createState() => _ViewUserProfileScreenState();
}

class _ViewUserProfileScreenState extends State<ViewUserProfileScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  final List<String> tabs = [
    'Offerings',
    'Asks',
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

  void _onTapSkillFunction(BuildContext context, User user, Skill skill) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ConfirmationDialogScreen(
        user: user,
        skill: skill,
        height:
            SizeConfig.instance.blockSizeVertical * kDialogScreenHeightBlocks,
        onConfirm: (comment) {
          BlocProvider.of<RequestBloc>(context).add(
            AddRequest(
              Request.create(
                skill: skill,
                comment: comment,
                receiverId: user.id,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildItemList(BuildContext context, String name, User user) {
    final skills = name == 'Offerings' ? user.teachSkill : user.learnSkill;

    return CustomScrollView(
      key: PageStorageKey<String>(name),
      slivers: <Widget>[
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        skills.length > 0
            ? SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final skill = skills[index];
                    final tapEnabled =
                        skill.duration != null && skill.name != null;

                    return SkillItem(
                      verticalPadding:
                          SizeConfig.instance.safeBlockVertical * 2,
                      horizontalPadding:
                          SizeConfig.instance.safeBlockHorizontal *
                              kHorizontalPaddingBlocks,
                      skill: skill,
                      tapEnabled: tapEnabled && !widget.editable,
                      onTap: () => _onTapSkillFunction(context, user, skill),
                    );
                  },
                  childCount: skills.length,
                ),
              )
            : SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.only(
                    left: SizeConfig.instance.safeBlockHorizontal * 12,
                    right: SizeConfig.instance.safeBlockHorizontal * 12,
                    top: SizeConfig.instance.safeBlockVertical * 15,
                    bottom: SizeConfig.instance.safeBlockVertical * 15,
                  ),
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Column(
                    children: <Widget>[
                      Text(
                        "${user.displayName} hasn't posted any ${name.toLowerCase()}",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .apply(fontWeightDelta: 3),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.instance.safeBlockVertical * 3,
                        ),
                        child: Text(
                          "When they do, they will show up here.",
                          style: Theme.of(context).textTheme.subtitle1.apply(
                                color: Palette.textSecondaryBaseColor,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }

  Widget _buildProfileWidget(BuildContext context, User user) {
    return user != null
        ? _buildProfile(context, user)
        : _buildBlocProfile(context);
  }

  Widget _buildBlocProfile(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (BuildContext context, ProfileState state) {
        if (state is ProfileUninitialized) {
          return Container();
        }

        if (state is ProfileLoading) {
          return Center(child: CupertinoActivityIndicator());
        }

        if (state is ProfileLoaded) {
          final user = state.user;
          return _buildProfile(context, user);
        }

        return Container();
      },
    );
  }

  NestedScrollView _buildProfile(BuildContext context, User user) {
    final titleTextStyle = Theme.of(context).textTheme.headline6;
    final bodyTextStyle = Theme.of(context).textTheme.bodyText1;
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverToBoxAdapter(
            child: Container(
              color: Palette.containerColor,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      left: SizeConfig.instance.safeBlockHorizontal *
                          kHorizontalPaddingBlocks,
                      right: SizeConfig.instance.safeBlockHorizontal *
                          kHorizontalPaddingBlocks,
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: kProfileSize,
                          child: Row(
                            children: <Widget>[
                              ProfilePicture(
                                photoUrl: user.photoUrl,
                                shape: BoxShape.circle,
                                editable: false,
                                size: kProfileSize,
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: SizeConfig
                                              .instance.safeBlockHorizontal *
                                          kHorizontalPaddingBlocks),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                          bottom: SizeConfig
                                                  .instance.safeBlockVertical *
                                              0.5,
                                        ),
                                        child: Text(
                                          user.displayName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              .apply(fontWeightDelta: 2),
                                        ),
                                      ),
                                      Text(
                                        user.title ?? '',
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
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.instance.safeBlockVertical,
                          ),
                          child: Text(user.about ?? '', style: bodyTextStyle),
                        ),
                        Visibility(
                          visible: widget.editable,
                          child: Container(
                            width: double.infinity,
                            child: FlatButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => UserProfileScreen(
                                    userRepository:
                                        BlocProvider.of<UserBloc>(context)
                                            .userRepository,
                                  ),
                                );
                              },
                              child: Text(
                                'Edit Profile',
                                style: Theme.of(context).textTheme.button.apply(
                                    fontWeightDelta: 1,
                                    color: Palette.primaryColor),
                              ),
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1, color: Palette.primaryColor),
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              top: SizeConfig.instance.safeBlockVertical * 0.5),
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                              children: user.interests
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
                ],
              ),
            ),
          ),
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: Palette.primaryColor,
                  unselectedLabelColor: Palette.textColor,
                  labelStyle: titleTextStyle,
                  // These are the widgets to put in each tab in the tab bar.
                  tabs: tabs
                      .map((String name) => Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: kTabBarTextPadding,
                            ),
                            child: Tab(child: Text(name)),
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
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
                return _buildItemList(context, name, user);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.scaffoldBackgroundDarkColor,
      appBar: AppBar(
        backgroundColor: Palette.containerColor,
        elevation: 0,
        leading: BackButton(
          color: Palette.primaryColor,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: _buildProfileWidget(context, widget.user),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 0.5,
            color: Colors.grey[400],
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
