import 'package:canteen_frontend/models/match/match.dart';
import 'package:canteen_frontend/models/message/message.dart';
import 'package:canteen_frontend/screens/match/arguments.dart';
import 'package:canteen_frontend/screens/match/match_detail_bloc/bloc.dart';
import 'package:canteen_frontend/screens/match/match_item.dart';
import 'package:canteen_frontend/screens/match/match_screen.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchList extends StatelessWidget {
  const MatchList({
    Key key,
    @required this.matches,
  }) : super(key: key);

  final List<DetailedMatch> matches;

  @override
  Widget build(BuildContext context) {
    final userId =
        CachedSharedPreferences.getString(PreferenceConstants.userId);

    return ListView.builder(
      itemCount: matches.length,
      itemBuilder: (context, index) {
        final match = matches[index];
        final partner =
            match.userList.where((u) => u.id != userId).toList().first;

        return MatchItem(
            displayName: partner.displayName,
            photoUrl: partner.photoUrl,
            message: match.lastMessage != null
                ? (match.lastMessage as TextMessage).text
                : '',
            time: match.lastUpdated,
            onTap: () {
              BlocProvider.of<MatchDetailBloc>(context)
                  .add(LoadMatch(match: match));
              Navigator.of(context).pushNamed(MatchScreen.routeName,
                  arguments: MatchArguments(match: match));
            });
      },
    );
  }
}
