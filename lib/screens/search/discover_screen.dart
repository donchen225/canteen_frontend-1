import 'package:canteen_frontend/components/profile_side_bar_button.dart';
import 'package:canteen_frontend/components/small_button.dart';
import 'package:canteen_frontend/components/view_user_profile_screen.dart';
import 'package:canteen_frontend/models/arguments.dart';
import 'package:canteen_frontend/models/discover/popular_user.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/profile/user_profile_screen.dart';
import 'package:canteen_frontend/screens/search/arguments.dart';
import 'package:canteen_frontend/screens/search/discover_bloc/bloc.dart';
import 'package:canteen_frontend/screens/search/group_card.dart';
import 'package:canteen_frontend/screens/search/profile_card.dart';
import 'package:canteen_frontend/screens/search/search_bar.dart';
import 'package:canteen_frontend/screens/search/searching_screen.dart';
import 'package:canteen_frontend/screens/search/view_group_screen.dart';
import 'package:canteen_frontend/shared_blocs/authentication/bloc.dart';
import 'package:canteen_frontend/shared_blocs/group/bloc.dart';
import 'package:canteen_frontend/shared_blocs/user/user_bloc.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuple/tuple.dart';

class DiscoverScreen extends StatelessWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    final userPhotoUrl =
        CachedSharedPreferences.getString(PreferenceConstants.userPhotoUrl);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(SizeConfig.instance.appBarHeight),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Palette.appBarBackgroundColor,
          elevation: 1,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ProfileSideBarButton(
                userPhotoUrl: userPhotoUrl,
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    SearchingScreen.routeName,
                  );
                },
                child: SearchBar(
                  height: SizeConfig.instance.appBarHeight * 0.75,
                  width: SizeConfig.instance.safeBlockHorizontal * 100 -
                      kProfileIconSize * 1.5 -
                      NavigationToolbar.kMiddleSpacing * 4,
                  color: Colors.grey[200],
                  child: Text(
                    "Search Canteen",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .apply(color: Palette.textSecondaryBaseColor),
                  ),
                ),
              ),
              Container(
                width: kProfileIconSize * 0.5,
              )
            ],
          ),
        ),
      ),
      body: BlocBuilder<DiscoverBloc, DiscoverState>(
        builder: (BuildContext context, DiscoverState state) {
          if (state is DiscoverUninitialized) {
            return Container();
          }

          if (state is DiscoverLoading) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }

          if (state is DiscoverLoaded) {
            return CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Visibility(
                    visible: BlocProvider.of<AuthenticationBloc>(context).state
                        is Authenticated,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: SizeConfig.instance.scaffoldBodyHeight * 0.02,
                        left: SizeConfig.instance.safeBlockHorizontal * 6,
                        right: SizeConfig.instance.safeBlockHorizontal * 6,
                      ),
                      child: Text('Recommended For You',
                          style: Theme.of(context).textTheme.headline5.apply(
                                fontFamily: '.SF UI Text',
                                fontWeightDelta: 2,
                              )),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Visibility(
                    visible: BlocProvider.of<AuthenticationBloc>(context).state
                        is Authenticated,
                    child: _buildRecommendationList(
                        context, state.recommendations),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: SizeConfig.instance.safeBlockHorizontal * 6,
                      right: SizeConfig.instance.safeBlockHorizontal * 6,
                      top: kDiscoverCardPadding / 2,
                    ),
                    child: Text('Popular Groups',
                        style: Theme.of(context).textTheme.headline5.apply(
                              fontFamily: '.SF UI Text',
                              fontWeightDelta: 2,
                            )),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: 260,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.groups.length,
                      itemBuilder: (context, index) {
                        final group = state.groups[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            left: index == 0
                                ? SizeConfig.instance.safeBlockHorizontal * 6
                                : 0,
                            right: SizeConfig.instance.safeBlockHorizontal * 6,
                            bottom: kDiscoverCardPadding,
                            top: kDiscoverCardPadding / 2,
                          ),
                          child: GroupCard(
                              group: group,
                              height: 260 - kDiscoverCardPadding * 1.5,
                              onTap: () {
                                BlocProvider.of<GroupBloc>(context)
                                    .add(LoadGroup(group));
                                Navigator.pushNamed(
                                  context,
                                  ViewGroupScreen.routeName,
                                  arguments: GroupArguments(group: group),
                                );
                              }),
                        );
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: SizeConfig.instance.safeBlockHorizontal * 6,
                      right: SizeConfig.instance.safeBlockHorizontal * 6,
                    ),
                    child: Text('Most Popular',
                        style: Theme.of(context).textTheme.headline5.apply(
                              fontFamily: '.SF UI Text',
                              fontWeightDelta: 2,
                            )),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildMostPopularList(context, state.popularUsers),
                ),
              ],
            );
          }

          return Container();
        },
      ),
    );
  }

  Widget _buildMostPopularList(
      BuildContext context, List<Tuple2<PopularUser, User>> users) {
    if (users == null || users.isEmpty) {
      return Container(
        padding: EdgeInsets.only(
          top: SizeConfig.instance.safeBlockVertical * 3,
          bottom: SizeConfig.instance.safeBlockVertical,
          left: SizeConfig.instance.safeBlockHorizontal * 9,
          right: SizeConfig.instance.safeBlockHorizontal * 9,
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                bottom: SizeConfig.instance.safeBlockVertical * 2,
              ),
              child: Text(
                'Most popular users are updated weekly. Come back next week!',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .apply(fontWeightDelta: 1),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      height: 360,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: users.length,
        itemBuilder: (context, index) {
          final userPair = users[index];
          final popularData = userPair.item1;
          final user = userPair.item2;

          if (popularData != null && popularData.skill != null) {
            return Padding(
              padding: EdgeInsets.only(
                left: index == 0
                    ? SizeConfig.instance.safeBlockHorizontal * 6
                    : 0,
                right: SizeConfig.instance.safeBlockHorizontal * 6,
                bottom: kDiscoverCardPadding,
                top: kDiscoverCardPadding / 2,
              ),
              child: ProfileCard(
                user: user,
                skill: popularData.skill,
                height: 360 - kDiscoverCardPadding * 2,
                onTap: () {
                  if (user != null) {
                    Navigator.pushNamed(
                      context,
                      ViewUserProfileScreen.routeName,
                      arguments: UserArguments(
                        user: user,
                      ),
                    );
                  }
                },
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildRecommendationList(
      BuildContext context, List<User> recommendations) {
    if (recommendations == null || recommendations.isEmpty) {
      return Container(
        padding: EdgeInsets.only(
          top: SizeConfig.instance.safeBlockVertical * 3,
          bottom: SizeConfig.instance.safeBlockVertical,
          left: SizeConfig.instance.safeBlockHorizontal * 9,
          right: SizeConfig.instance.safeBlockHorizontal * 9,
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                bottom: SizeConfig.instance.safeBlockVertical * 2,
              ),
              child: Text(
                'Update your offerings and asks to receive new recommendations!',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .apply(fontWeightDelta: 1),
                textAlign: TextAlign.center,
              ),
            ),
            SmallButton(
              text: 'Edit Profile',
              onPressed: () {
                final userRepository =
                    BlocProvider.of<UserBloc>(context).userRepository;

                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => UserProfileScreen(
                    userRepository: userRepository,
                  ),
                );
              },
            ),
          ],
        ),
      );
    }

    return Container(
      height: 360,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendations.length,
        itemBuilder: (context, index) {
          final user = recommendations[index];

          return Padding(
            padding: EdgeInsets.only(
              left: SizeConfig.instance.safeBlockHorizontal * 6,
              bottom: kDiscoverCardPadding / 2,
              top: kDiscoverCardPadding / 2,
            ),
            child: ProfileCard(
              user: user,
              height: 360 - kDiscoverCardPadding,
              onTap: () {
                if (user != null) {
                  Navigator.pushNamed(
                    context,
                    ViewUserProfileScreen.routeName,
                    arguments: UserArguments(
                      user: user,
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
