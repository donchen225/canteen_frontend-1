import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/search/search_bar.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:canteen_frontend/screens/search/search_result_item.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchResultScreen extends StatefulWidget {
  final String query;
  final List<User> results;

  SearchResultScreen({this.query, this.results}) : assert(query != null);

  @override
  _SearchResultScreenState createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  final List<String> tabChoices = ['People', 'Groups'];

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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        brightness: Brightness.light,
        backgroundColor: Palette.appBarBackgroundColor,
        elevation: 1,
        flexibleSpace: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final height = kToolbarHeight * 0.7;
              return Padding(
                padding: EdgeInsets.only(
                  left: constraints.maxWidth * 0.05,
                  right: constraints.maxWidth * 0.05,
                  top: kToolbarHeight * 0.18,
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.arrow_back_ios),
                        constraints: BoxConstraints(
                          minHeight: height,
                          minWidth: height,
                        ),
                        onPressed: () {
                          BlocProvider.of<SearchBloc>(context)
                              .add(SearchPreviousState());
                        },
                      ),
                      Flexible(
                        child: GestureDetector(
                          onTap: () {
                            BlocProvider.of<SearchBloc>(context).add(
                                EnterSearchQuery(initialQuery: widget.query));
                          },
                          child: SearchBar(
                            height: height,
                            color: Colors.grey[200],
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.query,
                                style:
                                    Theme.of(context).textTheme.subtitle1.apply(
                                          fontFamily: '.SF UI Text',
                                        ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        bottom: TabBar(
          indicatorSize: TabBarIndicatorSize.label,
          controller: _tabController,
          tabs: tabChoices.map((text) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: kTabBarTextPadding,
              ),
              child: Tab(
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.headline6.apply(
                        fontFamily: '.SF UI Text',
                        fontSizeFactor: kTabBarTextScaleFactor,
                        color: Palette.appBarTextColor,
                      ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
      body: ListView.builder(
          itemCount: widget.results.length,
          itemBuilder: (BuildContext context, int index) {
            final user = widget.results[index];
            return SearchResultItem(user: user);
          }),
    );
  }
}
