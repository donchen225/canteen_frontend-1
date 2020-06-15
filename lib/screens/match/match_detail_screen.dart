import 'package:canteen_frontend/components/view_user_profile_screen.dart';
import 'package:canteen_frontend/models/match/match.dart';
import 'package:canteen_frontend/screens/match/match_details_selection/match_details_event_selection.dart';
import 'package:canteen_frontend/screens/match/match_details_selection/video_chat_detail_screen.dart';
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
    Text('CHAT',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        )),
    Text('DETAILS',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        )),
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
                style: TextStyle(fontSize: 22, color: Colors.black),
              ),
              backgroundColor: Palette.appBarBackgroundColor,
              elevation: 1,
              bottom: !(state is MatchEventSelecting ||
                      state is MatchTimeSelecting ||
                      state is MatchPaying ||
                      state is MatchPaymentConfirming)
                  ? TabBar(
                      indicatorSize: TabBarIndicatorSize.label,
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(width: 2.0),
                        // insets: EdgeInsets.symmetric(horizontal: -10),
                      ),
                      indicatorColor: Colors.black,
                      controller: _tabController,
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
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey.shade400,
                    )
                  : null,
            ),
            body: Builder(
              builder: (BuildContext context) {
                if (state is MatchUninitialized || state is MatchLoading) {
                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                }

                if (state is MatchEventSelecting) {
                  return MatchDetailEventSelectionScreen(
                    user: user,
                    match: widget.match,
                  );
                }

                if (state is MatchPaying) {
                  return MatchPaymentScreen(
                    user: user,
                    match: widget.match,
                    skill: state.skill,
                    date: state.date,
                  );
                }

                if (state is MatchPaymentConfirming) {
                  return MatchPaymentConfirmationScreen(
                    user: user,
                    match: widget.match,
                    skill: state.skill,
                  );
                }

                if (state is MatchError) {
                  return Center(
                    child: Text('Match Error.'),
                  );
                }

                return TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    ChatScreen(
                      user: prospect,
                      match: widget.match,
                    ),
                    VideoChatDetailScreen(
                      user: user,
                      match: widget.match,
                      userDates: null,
                      partnerDates: null,
                    ),
                  ],
                );
              },
            ),
          );
        });
  }
}
