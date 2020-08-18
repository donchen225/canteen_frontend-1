import 'package:canteen_frontend/components/connection_request_dialog_screen.dart';
import 'package:canteen_frontend/components/interest_item.dart';
import 'package:canteen_frontend/components/unauthenticated_functions.dart';
import 'package:canteen_frontend/models/request/request_repository.dart';
import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/models/skill/skill_type.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/screens/profile/skill_item.dart';
import 'package:canteen_frontend/screens/profile/user_profile_bloc/bloc.dart';
import 'package:canteen_frontend/screens/profile/user_profile_screen.dart';
import 'package:canteen_frontend/screens/request/send_request_dialog/bloc/bloc.dart';
import 'package:canteen_frontend/shared_blocs/authentication/bloc.dart';
import 'package:canteen_frontend/shared_blocs/user/bloc.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfileBody extends StatefulWidget {
  final User user;
  final bool canConnect;
  final Widget headerWidget;

  UserProfileBody({this.user, this.canConnect = true, this.headerWidget});

  @override
  _UserProfileBodyState createState() => _UserProfileBodyState();
}

class _UserProfileBodyState extends State<UserProfileBody>
    with SingleTickerProviderStateMixin {
  User user;
  TabController _tabController;

  final List<String> tabs = [
    'Offerings',
    'Requests',
  ];

  @override
  void initState() {
    super.initState();

    user = widget.user;
    _tabController = TabController(vsync: this, length: tabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildItemList(BuildContext context, String name, User user) {
    final skillType = name == 'Offerings' ? SkillType.offer : SkillType.request;
    final skills =
        skillType == SkillType.offer ? user.teachSkill : user.learnSkill;

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

                    return SkillItem(
                      verticalPadding:
                          SizeConfig.instance.safeBlockVertical * 1.5,
                      horizontalPadding:
                          SizeConfig.instance.safeBlockHorizontal *
                              kHorizontalPaddingBlocks,
                      skill: skill,
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

  Widget _buildMainWidget() {
    final userId =
        CachedSharedPreferences.getString(PreferenceConstants.userId);

    if (widget.user.id == userId) {
      return Container(
        width: double.infinity,
        child: FlatButton(
          onPressed: () async {
            final userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
            final userRepository =
                BlocProvider.of<UserBloc>(context).userRepository;

            await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => UserProfileScreen(
                userRepository: userRepository,
              ),
            );

            final state = userProfileBloc.state;

            setState(() {
              if (state is UserProfileLoaded) {
                user = state.user;
              } else {
                user = userRepository.currentUserNow();
              }
            });
          },
          child: Text(
            'Edit Profile',
            style: Theme.of(context)
                .textTheme
                .button
                .apply(fontWeightDelta: 1, color: Palette.primaryColor),
          ),
          shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Palette.primaryColor),
              borderRadius: BorderRadius.circular(10.0)),
        ),
      );
    } else if (widget.canConnect) {
      return Container(
        width: double.infinity,
        child: FlatButton(
          color: Palette.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            'Connect',
            style: Theme.of(context).textTheme.button.apply(
                  fontWeightDelta: 1,
                  color: Palette.buttonDarkTextColor,
                ),
          ),
          onPressed: () {
            final authenticated = BlocProvider.of<AuthenticationBloc>(context)
                .state is Authenticated;

            if (authenticated) {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  final sendRequetBloc =
                      SendRequestBloc(requestRepository: RequestRepository());
                  return BlocProvider<SendRequestBloc>(
                    create: (dialogContext) => sendRequetBloc,
                    child: ConnectionRequestDialogScreen(
                      user: user,
                      onConfirm: (String comment,
                          DateTime time,
                          Skill skill,
                          int index,
                          String referralId,
                          String refferalComment) {
                        sendRequetBloc.add(
                          SendRequest(
                            receiverId: user.id,
                            referralId: referralId,
                            comment: comment,
                            referralComment: refferalComment,
                            index: index,
                            type: skill.type.name,
                            time: time,
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            } else {
              UnauthenticatedFunctions.showSignUp(context);
            }
          },
        ),
      );
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    final titleTextStyle = Theme.of(context).textTheme.headline6;
    final bodyTextStyle = Theme.of(context).textTheme.bodyText2;

    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverToBoxAdapter(
            child: Container(
              color: Palette.containerColor,
              padding: EdgeInsets.only(
                left: SizeConfig.instance.safeBlockHorizontal *
                    kHorizontalPaddingBlocks,
                right: SizeConfig.instance.safeBlockHorizontal *
                    kHorizontalPaddingBlocks,
              ),
              child: Column(
                children: <Widget>[
                  widget.headerWidget ?? Container(),
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
                                horizontal:
                                    SizeConfig.instance.safeBlockHorizontal *
                                        kHorizontalPaddingBlocks),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom:
                                        SizeConfig.instance.safeBlockVertical *
                                            0.5,
                                  ),
                                  child: Text(
                                    user.displayName ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .apply(
                                          fontWeightDelta: 2,
                                          heightFactor: 0.88,
                                        ),
                                  ),
                                ),
                                Text(
                                  user.title ?? '',
                                  style: bodyTextStyle.apply(
                                    color: Palette.textSecondaryBaseColor,
                                    heightFactor: 0.9,
                                  ),
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
                  Container(
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
                  _buildMainWidget(),
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
