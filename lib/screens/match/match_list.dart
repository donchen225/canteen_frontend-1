import 'package:canteen_frontend/models/user/firebase_user_repository.dart';
import 'package:canteen_frontend/screens/match/match_detail_bloc/bloc.dart';
import 'package:canteen_frontend/screens/match/match_detail_navigation_bloc/bloc/bloc.dart';
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
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) {
                        BlocProvider.of<MatchDetailBloc>(context).add(
                            LoadVideoChatDetails(
                                matchId: match.id,
                                videoChatId: match.activeVideoChat));
                        return BlocProvider<MatchDetailNavigationBloc>(
                          create: (BuildContext context) =>
                              MatchDetailNavigationBloc(),
                          child: MatchDetailScreen(match: match),
                        );
                      }),
                    );
                  });
            },
          );
        }
      },
    );
  }
}
