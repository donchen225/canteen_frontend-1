import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/recommended/bloc/bloc.dart';
import 'package:canteen_frontend/screens/search/profile_card.dart';
import 'package:canteen_frontend/screens/search/search_bar.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        brightness: Brightness.light,
        backgroundColor: Palette.appBarBackgroundColor,
        elevation: 1,
        flexibleSpace: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final height = kToolbarHeight * 0.7;
              return Padding(
                padding: EdgeInsets.only(
                  left: constraints.maxWidth * 0.05,
                  right: constraints.maxWidth * 0.05,
                  top: kToolbarHeight * 0.18,
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: GestureDetector(
                    onTap: () {
                      BlocProvider.of<SearchBloc>(context)
                          .add(EnterSearchQuery());
                    },
                    child: SearchBar(
                      height: height,
                      color: Colors.grey[200],
                      child: Align(
                        alignment: Alignment.centerLeft,
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
              );
            },
          ),
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
                            onTap: () =>
                                BlocProvider.of<SearchBloc>(context).add(
                              SearchInspectUser(user),
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
              height: SizeConfig.instance.scaffoldBodyHeight * 0.55,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  final user = userList[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      left: SizeConfig.instance.safeBlockHorizontal * 6,
                      bottom: SizeConfig.instance.scaffoldBodyHeight * 0.03,
                      top: SizeConfig.instance.scaffoldBodyHeight * 0.03,
                    ),
                    child: ProfileCard(
                      user: user,
                      height: SizeConfig.instance.scaffoldBodyHeight * 0.44,
                      onTap: () => BlocProvider.of<SearchBloc>(context).add(
                        SearchInspectUser(user),
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
