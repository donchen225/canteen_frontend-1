import 'package:canteen_frontend/screens/match/arguments.dart';
import 'package:canteen_frontend/screens/match/match_detail_bloc/bloc.dart';
import 'package:canteen_frontend/screens/match/match_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:canteen_frontend/screens/match/match_list_bloc/bloc.dart';
import 'package:canteen_frontend/screens/match/match_item.dart';

class MatchList extends StatelessWidget {
  MatchList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchListBloc, MatchListState>(
      builder: (matchContext, matchState) {
        if (matchState is MatchListLoading) {
          return Center(child: CupertinoActivityIndicator());
        } else if (matchState is MatchListLoaded) {
          final matches = matchState.matchList;

          return ListView.builder(
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final match = matches[index];

              return MatchItem(
                  match: match,
                  onTap: () async {
                    BlocProvider.of<MatchDetailBloc>(context)
                        .add(LoadMatchDetails(match: match));
                    Navigator.of(context).pushNamed(MatchDetailScreen.routeName,
                        arguments: MatchArguments(match: match));
                  });
            },
          );
        }
      },
    );
  }
}
