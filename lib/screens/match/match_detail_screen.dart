import 'package:canteen_frontend/models/chat/chat.dart';
import 'package:canteen_frontend/models/match/match.dart';
import 'package:canteen_frontend/screens/chat/chat_screen.dart';
import 'package:canteen_frontend/screens/profile/profile_list.dart';
import 'package:canteen_frontend/shared_blocs/user/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class MatchDetailScreen extends StatefulWidget {
  final DetailedMatch match;
  final Chat chat;

  MatchDetailScreen({Key key, @required this.match, @required this.chat})
      : super(key: key);

  @override
  _MatchDetailScreenState createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  // final _myTabbedPageKey = new GlobalKey<_MatchDetailScreenState>();

  List<Text> tabChoices = [
    Text('CHAT',
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
    super.initState();
    _tabController = TabController(vsync: this, length: tabChoices.length);
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

    final tabWidgets = [
      ChatScreen(
        user: prospect,
        chat: widget.chat,
      ),
      ProfileList(prospect, height: 100),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          prospect.displayName ?? prospect.email,
          style: GoogleFonts.montserrat(fontSize: 22, color: Colors.black),
        ),
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 6,
        leading: BackButton(
          color: Colors.black,
        ),
        bottom: TabBar(
          indicatorColor: Colors.black,
          controller: _tabController,
          tabs: tabChoices.map((text) {
            return Tab(
              child: text,
            );
          }).toList(),
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey.shade400,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabWidgets,
      ),
    );
  }
}
