import 'package:canteen_frontend/components/platform/platform_loading_indicator.dart';
import 'package:canteen_frontend/components/small_button.dart';
import 'package:canteen_frontend/components/unauthenticated_functions.dart';
import 'package:canteen_frontend/screens/match/match_list.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:canteen_frontend/screens/match/match_list_bloc/bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MatchListScreen extends StatelessWidget {
  MatchListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchListBloc, MatchListState>(
      builder: (matchContext, matchState) {
        if (matchState is MatchListLoading) {
          return Center(child: PlatformLoadingIndicator());
        } else if (matchState is MatchListUnauthenticated) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                FontAwesomeIcons.commentDots,
                color: Colors.grey,
                size: 80,
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.instance.safeBlockVertical,
                  bottom: SizeConfig.instance.safeBlockVertical * 2,
                ),
                child: Text('Messages will appear here',
                    style: Theme.of(context).textTheme.bodyText2),
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
