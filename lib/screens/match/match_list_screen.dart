import 'package:canteen_frontend/components/small_button.dart';
import 'package:canteen_frontend/components/unauthenticated_functions.dart';
import 'package:canteen_frontend/screens/match/match_list.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:canteen_frontend/screens/match/match_list_bloc/bloc.dart';

class MatchListScreen extends StatelessWidget {
  MatchListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchListBloc, MatchListState>(
      builder: (matchContext, matchState) {
        if (matchState is MatchListLoading) {
          return Center(child: CupertinoActivityIndicator());
        } else if (matchState is MatchListUnauthenticated) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                IconData(0xf38d,
                    fontFamily: CupertinoIcons.iconFont,
                    fontPackage: CupertinoIcons.iconFontPackage),
                size: 70,
                color: Colors.grey,
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.instance.safeBlockVertical,
                  bottom: SizeConfig.instance.safeBlockVertical * 2,
                ),
                child: Text('Messages will appear here',
                    style: Theme.of(context).textTheme.bodyText1),
              ),
              SmallButton(
                text: 'Sign Up',
                onPressed: () => UnauthenticatedFunctions.showSignUp(context),
              ),
            ],
          );
        } else if (matchState is MatchListLoaded) {
          final matches = matchState.matchList;

          return MatchList(matches: matches);
        }
        return Container();
      },
    );
  }
}
