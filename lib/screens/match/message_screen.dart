import 'package:canteen_frontend/screens/match/match_list.dart';
import 'package:canteen_frontend/screens/request/request_screen.dart';
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

  final List<String> tabChoices = ['Chats', 'Requests'];

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
          style: Theme.of(context).textTheme.headline6.apply(
                fontFamily: '.SF UI Text',
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
              child: Text(
                text,
                style: Theme.of(context).textTheme.headline6.apply(
                      fontFamily: '.SF UI Text',
                      fontSizeFactor: 0.8,
                      color: Palette.appBarTextColor,
                    ),
              ),
            );
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[MatchList(), RequestScreen()],
      ),
    );
  }
}
