import 'package:canteen_frontend/screens/match/match_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:canteen_frontend/screens/match/match_list_bloc/bloc.dart';
import 'package:canteen_frontend/screens/match/match_item.dart';

class MatchList extends StatelessWidget {
  MatchList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchListBloc, MatchListState>(
        builder: (context, state) {
      if (state is MatchListLoading || state is MatchListLoaded) {
        // TODO: show something when in MatchListLoaded state
        return Center(child: CircularProgressIndicator());
      } else if (state is DetailedMatchListLoaded) {
        final matches = state.matchList;
        return ListView.builder(
          itemCount: matches.length,
          itemBuilder: (context, index) {
            final match = matches[index];
            return MatchItem(
                match: match,
                onTap: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) {
                      return MatchDetailScreen(match: match);
                    }),
                  );
                });
          },
        );
      }
    });
  }
}
