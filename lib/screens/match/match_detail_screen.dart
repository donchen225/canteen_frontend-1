import 'package:canteen_frontend/models/match/match.dart';
import 'package:canteen_frontend/screens/match/match_details_selection/match_details_event_selection.dart';
import 'package:canteen_frontend/screens/match/match_details_selection/match_payment_confirmation_screen.dart';
import 'package:canteen_frontend/screens/match/match_details_selection/match_payment_screen.dart';
import 'package:canteen_frontend/screens/message/chat_screen.dart';
import 'package:canteen_frontend/screens/match/match_detail_bloc/bloc.dart';
import 'package:canteen_frontend/shared_blocs/user/bloc.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchDetailScreen extends StatefulWidget {
  static const routeName = '/match';
  final DetailedMatch match;

  MatchDetailScreen({Key key, @required this.match}) : super(key: key);

  @override
  _MatchDetailScreenState createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen>
    with SingleTickerProviderStateMixin {
  MatchDetailBloc _matchDetailBloc;
  TabController _tabController;

  final List<Text> tabChoices = [
    Text(
      'Chat',
    ),
    Text(
      'Details',
    ),
  ];

  @override
  void initState() {
    print('INIT MATCH DETAIL SCREEN');
    super.initState();
    _tabController = TabController(vsync: this, length: tabChoices.length);
    _matchDetailBloc = BlocProvider.of<MatchDetailBloc>(context);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = (BlocProvider.of<UserBloc>(context).state as UserLoaded).user;
    final prospect = widget.match.userList.firstWhere((u) => u.id != user.id);

    return BlocBuilder<MatchDetailBloc, MatchDetailState>(
        bloc: _matchDetailBloc,
        builder: (BuildContext context, MatchDetailState state) {
          return Scaffold(
            appBar: AppBar(
              leading: BackButton(
                color: Palette.primaryColor,
              ),
              title: Text(
                prospect.displayName ?? prospect.email,
                style: Theme.of(context).textTheme.headline6.apply(
                      color: Palette.appBarTextColor,
                      fontWeightDelta: 2,
                    ),
              ),
              backgroundColor: Palette.appBarBackgroundColor,
              elevation: 1,
              bottom: TabBar(
                indicatorSize: TabBarIndicatorSize.label,
                controller: _tabController,
                labelColor: Palette.primaryColor,
                unselectedLabelColor: Palette.appBarTextColor,
                labelStyle: Theme.of(context).textTheme.headline6,
                tabs: tabChoices.map((text) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: kTabBarTextPadding,
                    ),
                    child: Tab(
                      child: text,
                    ),
                  );
                }).toList(),
              ),
            ),
            body: Builder(
              builder: (BuildContext context) {
                if (state is MatchUninitialized || state is MatchLoading) {
                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                }

                // if (state is MatchEventSelecting) {
                //   return MatchDetailEventSelectionScreen(
                //     user: user,
                //     match: widget.match,
                //   );
                // }

                // if (state is MatchPaying) {
                //   return MatchPaymentScreen(
                //     user: user,
                //     match: widget.match,
                //     skill: state.skill,
                //     date: state.date,
                //   );
                // }

                // if (state is MatchPaymentConfirming) {
                //   return MatchPaymentConfirmationScreen(
                //     user: user,
                //     match: widget.match,
                //     skill: state.skill,
                //   );
                // }

                // if (state is MatchError) {
                //   return Center(
                //     child: Text('Match Error.'),
                //   );
                // }

                return TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    ChatScreen(
                      user: prospect,
                      match: widget.match,
                    ),
                    ChatScreen(
                      user: prospect,
                      match: widget.match,
                    ),
                  ],
                );
              },
            ),
          );
        });
  }
}
