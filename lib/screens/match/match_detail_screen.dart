import 'package:canteen_frontend/models/match/match.dart';
import 'package:canteen_frontend/screens/match/match_detail_navigation_bloc/bloc/bloc.dart';
import 'package:canteen_frontend/screens/match/video_chat_details/video_chat_detail_initial_screen.dart';
import 'package:canteen_frontend/screens/match/video_chat_details/video_chat_detail_screen.dart';
import 'package:canteen_frontend/screens/match/video_chat_details/video_chat_payment_screen.dart';
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
              bottom: !(state is MatchUninitialized || state is MatchUnpaid)
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
                if (state is MatchLoading) {
                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                }

                if (state is MatchUninitialized) {
                  print('IN MATCHUNINITIALIZED');
                  return VideoChatDetailInitialScreen(
                    user: user,
                    match: widget.match,
                  );
                }

                if (state is MatchUnpaid) {
                  return VideoChatPaymentScreen(
                    user: user,
                    match: widget.match,
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
