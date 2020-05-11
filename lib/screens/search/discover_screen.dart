import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/search/profile_card.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscoverScreen extends StatelessWidget {
  final List<User> userList;

  DiscoverScreen(this.userList) : assert(userList != null);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
            height: SizeConfig.instance.safeBlockVertical * 30,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  width: 100.0,
                  child: Card(
                    child: Text('data'),
                  ),
                );
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
                      onTap: () => BlocProvider.of<SearchBloc>(context)
                          .add(SearchInspectUser(user))),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
