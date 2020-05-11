import 'package:canteen_frontend/screens/match/match_list.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  MessageScreen({Key key}) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  final List<Text> tabChoices = [
    Text('Chats',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        )),
    Text('Requests',
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        title: Text(
          'Messages',
          style: TextStyle(
            color: Palette.appBarTextColor,
          ),
        ),
        backgroundColor: Palette.appBarBackgroundColor,
        automaticallyImplyLeading: false,
        elevation: 1,
        bottom: TabBar(
          controller: _tabController,
          tabs: tabChoices.map((text) {
            return Tab(
              child: text,
            );
          }).toList(),
        ),
      ),
      body: MatchList(),
    );
  }
}
