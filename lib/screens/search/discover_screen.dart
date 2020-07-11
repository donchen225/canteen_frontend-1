import 'package:canteen_frontend/components/profile_side_bar_button.dart';
import 'package:canteen_frontend/components/small_button.dart';
import 'package:canteen_frontend/components/view_user_profile_screen.dart';
import 'package:canteen_frontend/models/arguments.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/profile/user_profile_screen.dart';
import 'package:canteen_frontend/screens/search/arguments.dart';
import 'package:canteen_frontend/screens/search/discover_bloc/bloc.dart';
import 'package:canteen_frontend/screens/search/group_card.dart';
import 'package:canteen_frontend/screens/search/profile_card.dart';
import 'package:canteen_frontend/screens/search/search_bar.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
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

class DiscoverScreen extends StatelessWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    final userPhotoUrl =
        CachedSharedPreferences.getString(PreferenceConstants.userPhotoUrl);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
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
                final searchHistory =
                    BlocProvider.of<SearchBloc>(context).searchHistory;
                Navigator.pushNamed(
                  context,
                  SearchingScreen.routeName,
                  arguments: SearchArguments(
                    searchHistory: searchHistory
                        .map((q) => q.displayQuery)
                        .toList()
                        .reversed
                        .toList(),
                  ),
                );
              },
              child: SearchBar(
                height: kToolbarHeight * 0.7,
                width: SizeConfig.instance.safeBlockHorizontal * 100 -
                    kProfileIconSize * 1.5 -
                    NavigationToolbar.kMiddleSpacing * 4,
                color: Colors.grey[200],
                child: Text(
                  "Search Canteen",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
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
                        bottom: SizeConfig.instance.scaffoldBodyHeight * 0.01,
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
                      top: SizeConfig.instance.scaffoldBodyHeight * 0.03,
                      left: SizeConfig.instance.safeBlockHorizontal * 6,
                      right: SizeConfig.instance.safeBlockHorizontal * 6,
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
                    height: 280,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.groups.length,
                      itemBuilder: (context, index) {
                        final group = state.groups[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            left: SizeConfig.instance.safeBlockHorizontal * 6,
                            bottom:
                                SizeConfig.instance.scaffoldBodyHeight * 0.03,
                            top: SizeConfig.instance.scaffoldBodyHeight * 0.03,
                          ),
                          child: GroupCard(
                              group: group,
                              height: 280 * 0.9,
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
                      top: SizeConfig.instance.scaffoldBodyHeight * 0.03,
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
                  child: Container(
                    height: 350,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.popularUsers.length,
                      itemBuilder: (context, index) {
                        final userPair = state.popularUsers[index];
                        final popularData = userPair.item1;
                        final user = userPair.item2;

                        if (popularData != null && popularData.skill != null) {
                          return Padding(
                            padding: EdgeInsets.only(
                              left: SizeConfig.instance.safeBlockHorizontal * 6,
                              bottom:
                                  SizeConfig.instance.scaffoldBodyHeight * 0.03,
                              top:
                                  SizeConfig.instance.scaffoldBodyHeight * 0.03,
                            ),
                            child: ProfileCard(
                              user: user,
                              skill: popularData.skill,
                              height:
                                  SizeConfig.instance.scaffoldBodyHeight * 0.44,
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
                  ),
                ),
              ],
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
                    .bodyText1
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
      height: SizeConfig.instance.scaffoldBodyHeight * 0.55,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendations.length,
        itemBuilder: (context, index) {
          final user = recommendations[index];

          return Padding(
            padding: EdgeInsets.only(
              left: SizeConfig.instance.safeBlockHorizontal * 6,
              bottom: SizeConfig.instance.scaffoldBodyHeight * 0.03,
              top: SizeConfig.instance.scaffoldBodyHeight * 0.03,
            ),
            child: ProfileCard(
              user: user,
              height: SizeConfig.instance.scaffoldBodyHeight * 0.49,
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
