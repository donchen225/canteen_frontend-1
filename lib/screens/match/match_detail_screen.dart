import 'package:canteen_frontend/models/match/match.dart';
import 'package:canteen_frontend/screens/match/match_detail_navigation_bloc/bloc/bloc.dart';
import 'package:canteen_frontend/screens/match/match_details_selection/match_details_event_selection.dart';
import 'package:canteen_frontend/screens/match/match_details_selection/match_detail_time_selection_screen.dart';
import 'package:canteen_frontend/screens/match/match_details_selection/match_waiting_screen.dart';
import 'package:canteen_frontend/screens/match/match_details_selection/video_chat_detail_screen.dart';
import 'package:canteen_frontend/screens/match/match_details_selection/match_payment_confirmation_screen.dart';
import 'package:canteen_frontend/screens/match/match_details_selection/match_payment_screen.dart';
import 'package:canteen_frontend/screens/message/chat_screen.dart';
import 'package:canteen_frontend/components/profile_list.dart';
import 'package:canteen_frontend/screens/match/match_detail_bloc/bloc.dart';
import 'package:canteen_frontend/shared_blocs/user/bloc.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class MatchDetailScreen extends StatefulWidget {
  final DetailedMatch match;

  MatchDetailScreen({Key key, @required this.match}) : super(key: key);

  @override
  _MatchDetailScreenState createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen>
    with SingleTickerProviderStateMixin {
  MatchDetailBloc _matchDetailBloc;
  MatchDetailNavigationBloc _matchDetailNavigationBloc;
  TabController _tabController;

  List<Text> tabChoices = [
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
    Text('PROFILE',
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
    _matchDetailNavigationBloc =
        BlocProvider.of<MatchDetailNavigationBloc>(context);
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
              brightness: Brightness.light,
              title: Text(
                prospect.displayName ?? prospect.email,
                style:
                    GoogleFonts.montserrat(fontSize: 22, color: Colors.black),
              ),
              backgroundColor: Palette.appBarBackgroundColor,
              elevation: 1,
              bottom: !(state is MatchEventSelecting ||
                      state is MatchTimeSelecting ||
                      state is MatchPaying ||
                      state is MatchPaymentConfirming)
                  ? TabBar(
                      indicatorColor: Colors.black,
                      controller: _tabController,
                      tabs: tabChoices.map((text) {
                        return Tab(
                          child: text,
                        );
                      }).toList(),
                      onTap: (index) {
                        _matchDetailNavigationBloc.add(TabTapped(index: index));
                      },
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

                if (state is MatchTimeSelecting) {
                  return MatchDetailTimeSelectionScreen(
                    user: prospect,
                    match: widget.match,
                    skill: state.skill,
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

                if (_matchDetailNavigationBloc.state
                    is MatchNavigationUninitialized) {
                  _matchDetailNavigationBloc.add(TabTapped(index: 0));
                }

                return BlocBuilder<MatchDetailNavigationBloc,
                    MatchDetailNavigationState>(
                  bloc: _matchDetailNavigationBloc,
                  builder: (BuildContext context,
                      MatchDetailNavigationState navState) {
                    if (navState is MatchNavigationUninitialized ||
                        navState is PageLoading ||
                        navState is CurrentIndexChanged) {
                      return Center(child: CupertinoActivityIndicator());
                    }

                    if (state is MatchWaiting &&
                        !(navState is ProfileScreenLoaded)) {
                      return MatchWaitingScreen();
                    }

                    if (navState is ChatScreenLoaded) {
                      return ChatScreen(
                        user: prospect,
                        match: widget.match,
                      );
                    }

                    if (navState is VideoChatDetailScreenLoaded) {
                      return VideoChatDetailScreen(
                        user: user,
                        match: widget.match,
                        userDates: null,
                        partnerDates: null,
                      );
                    }

                    if (navState is ProfileScreenLoaded) {
                      return CustomScrollView(
                        slivers: <Widget>[
                          SliverPadding(
                            padding: EdgeInsets.only(
                                top: SizeConfig.instance.blockSizeVertical * 3,
                                left:
                                    SizeConfig.instance.blockSizeHorizontal * 3,
                                right:
                                    SizeConfig.instance.blockSizeHorizontal * 3,
                                bottom:
                                    SizeConfig.instance.blockSizeVertical * 13),
                            sliver: ProfileList(prospect, height: 100),
                          )
                        ],
                      );
                    }

                    return Container();
                  },
                );
              },
            ),
          );
        });
  }
}
