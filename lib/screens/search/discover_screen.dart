import 'package:canteen_frontend/components/profile_side_bar_button.dart';
import 'package:canteen_frontend/components/view_user_profile_screen.dart';
import 'package:canteen_frontend/models/arguments.dart';
import 'package:canteen_frontend/screens/recommended/bloc/bloc.dart';
import 'package:canteen_frontend/screens/search/arguments.dart';
import 'package:canteen_frontend/screens/search/profile_card.dart';
import 'package:canteen_frontend/screens/search/search_bar.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:canteen_frontend/screens/search/searching_screen.dart';
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
                    kProfileIconSize * 2 -
                    NavigationToolbar.kMiddleSpacing * 4,
                color: Colors.grey[200],
                child: Text(
                  "What are you looking for?",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .apply(color: Palette.textSecondaryBaseColor),
                ),
              ),
            ),
            Container(
              width: kProfileIconSize,
            )
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
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
          SliverToBoxAdapter(
            child: Container(
              height: SizeConfig.instance.scaffoldBodyHeight * 0.55,
              child: BlocBuilder<RecommendedBloc, RecommendedState>(
                builder: (BuildContext context, RecommendedState state) {
                  if (state is RecommendedLoading) {
                    return CupertinoActivityIndicator();
                  }

                  if (state is RecommendedLoaded) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.recommendations.length,
                      itemBuilder: (context, index) {
                        final user = state.recommendations[index];

                        return Padding(
                          padding: EdgeInsets.only(
                            left: SizeConfig.instance.safeBlockHorizontal * 6,
                            bottom:
                                SizeConfig.instance.scaffoldBodyHeight * 0.03,
                            top: SizeConfig.instance.scaffoldBodyHeight * 0.03,
                          ),
                          child: ProfileCard(
                            user: user,
                            height:
                                SizeConfig.instance.scaffoldBodyHeight * 0.49,
                            onTap: () => Navigator.pushNamed(
                              context,
                              ViewUserProfileScreen.routeName,
                              arguments: UserArguments(
                                user: user,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return Container();
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
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (BuildContext context, SearchState state) {
                if (state is SearchUninitialized) {
                  final userList = state.allUsers;

                  return Container(
                    height: SizeConfig.instance.scaffoldBodyHeight * 0.55,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: userList.length,
                      itemBuilder: (context, index) {
                        final user = userList[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            left: SizeConfig.instance.safeBlockHorizontal * 6,
                            bottom:
                                SizeConfig.instance.scaffoldBodyHeight * 0.03,
                            top: SizeConfig.instance.scaffoldBodyHeight * 0.03,
                          ),
                          child: ProfileCard(
                            user: user,
                            height:
                                SizeConfig.instance.scaffoldBodyHeight * 0.44,
                            onTap: () => Navigator.pushNamed(
                              context,
                              ViewUserProfileScreen.routeName,
                              arguments: UserArguments(
                                user: user,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
