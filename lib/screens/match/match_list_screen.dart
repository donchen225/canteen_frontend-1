import 'package:canteen_frontend/screens/match/match_list.dart';
import 'package:canteen_frontend/utils/palette.dart';
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
              Icon(
                Icons.sms,
                size: 50,
                color: Colors.grey,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.instance.safeBlockVertical,
                ),
                child: Text('Messages will appear here'),
              ),
              FlatButton(
                color: Palette.primaryColor,
                child: Text(
                  'Sign Up',
                  style: Theme.of(context).textTheme.button.apply(
                        color: Palette.whiteColor,
                      ),
                ),
                onPressed: () {},
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
