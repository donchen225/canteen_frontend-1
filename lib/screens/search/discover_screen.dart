import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/recommended/bloc/bloc.dart';
import 'package:canteen_frontend/screens/search/profile_card.dart';
import 'package:canteen_frontend/screens/search/search_bar.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:canteen_frontend/screens/search/view_user_profile_screen.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscoverScreen extends StatelessWidget {
  final List<User> userList;

  DiscoverScreen(this.userList) : assert(userList != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          SizeConfig.instance.safeBlockVertical * 10,
        ),
        child: AppBar(
          automaticallyImplyLeading: false,
          brightness: Brightness.light,
          backgroundColor: Palette.appBarBackgroundColor,
          elevation: 1,
          flexibleSpace: SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.instance.safeBlockHorizontal * 6,
                ),
                child: GestureDetector(
                  onTap: () {
                    BlocProvider.of<SearchBloc>(context)
                        .add(EnterSearchQuery());
                  },
                  child: SearchBar(
                    height: SizeConfig.instance.safeBlockVertical * 5,
                    color: Colors.grey[200],
                    child: Text(
                      "What are you looking for?",
                      style: Theme.of(context).textTheme.subtitle1.apply(
                            fontFamily: '.SF UI Text',
                            fontWeightDelta: 2,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                top: SizeConfig.instance.safeBlockVertical * 3,
                bottom: SizeConfig.instance.safeBlockVertical,
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
              height: SizeConfig.instance.safeBlockVertical * 50,
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
                            bottom: SizeConfig.instance.safeBlockVertical * 3,
                            top: SizeConfig.instance.safeBlockVertical * 3,
                          ),
                          child: ProfileCard(
                            user: user,
                            height: SizeConfig.instance.safeBlockVertical * 46,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) {
                                return ViewUserProfileScreen(user: user);
                              }),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  print(state);
                  return Container();
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                top: SizeConfig.instance.safeBlockVertical * 3,
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
              height: SizeConfig.instance.safeBlockVertical * 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  final user = userList[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      left: SizeConfig.instance.safeBlockHorizontal * 6,
                      bottom: SizeConfig.instance.safeBlockVertical * 3,
                      top: SizeConfig.instance.safeBlockVertical * 3,
                    ),
                    child: ProfileCard(
                      user: user,
                      height: SizeConfig.instance.safeBlockVertical * 46,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) {
                          return ViewUserProfileScreen(user: user);
                        }),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
