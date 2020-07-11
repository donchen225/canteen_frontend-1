import 'package:canteen_frontend/screens/search/arguments.dart';
import 'package:canteen_frontend/screens/search/search_bar.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:canteen_frontend/screens/search/search_results_screen.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:math' as math;

class SearchingScreen extends StatefulWidget {
  final String initialQuery;
  final List<String> searchHistory;
  static const routeName = '/search';

  SearchingScreen({this.initialQuery, this.searchHistory});

  @override
  _SearchingScreenState createState() => _SearchingScreenState();
}

class _SearchingScreenState extends State<SearchingScreen> {
  TextEditingController _searchController;

  @override
  void initState() {
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    _searchController.text = widget.initialQuery ?? '';
    _searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: _searchController.text.length));

    final textTheme = Theme.of(context).textTheme.bodyText2;

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kAppBarHeight),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Palette.appBarBackgroundColor,
            elevation: 1,
            flexibleSpace: SafeArea(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final height = kAppBarHeight * 0.75;

                  return Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(
                      left: constraints.maxWidth * 0.05,
                      right: constraints.maxWidth * 0.05,
                    ),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: SearchBar(
                            height: height,
                            color: Colors.grey[200],
                            child: TextField(
                              controller: _searchController,
                              autofocus: true,
                              autocorrect: false,
                              textInputAction: TextInputAction.search,
                              style: textTheme,
                              decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                hintText: "Search skills, groups, people",
                                hintStyle: textTheme.apply(
                                  color: Colors.grey[400],
                                ),
                              ),
                              onSubmitted: (String query) {
                                // TODO: add minimum of 2 characters
                                BlocProvider.of<SearchBloc>(context)
                                    .add(SearchStarted(query));
                                Navigator.pushNamed(
                                  context,
                                  SearchResultScreen.routeName,
                                  arguments: SearchResultsArguments(
                                    query: query,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).maybePop();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: height,
                            padding: EdgeInsets.only(
                              left: SizeConfig.instance.safeBlockHorizontal * 3,
                            ),
                            child: Text(
                              'Cancel',
                              style: textTheme.apply(
                                color: Palette.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        body: ListView.builder(
            itemCount: widget.searchHistory.length,
            itemBuilder: (BuildContext context, int index) {
              final query = widget.searchHistory[index];
              return GestureDetector(
                onTap: () {
                  BlocProvider.of<SearchBloc>(context)
                      .add(SearchStarted(query));
                  Navigator.pushNamed(
                    context,
                    SearchResultScreen.routeName,
                    arguments: SearchResultsArguments(
                      query: query,
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.only(
                    top: SizeConfig.instance.safeBlockVertical * 2,
                    bottom: SizeConfig.instance.safeBlockVertical * 2,
                    left: SizeConfig.instance.safeBlockHorizontal * 6,
                    right: SizeConfig.instance.safeBlockHorizontal * 6,
                  ),
                  decoration: BoxDecoration(
                    color: Palette.containerColor,
                    border: Border(
                      top: BorderSide(
                        width: 0.5,
                        color: Colors.grey[300],
                      ),
                      bottom: BorderSide(
                        width: 0.5,
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        query,
                        style: textTheme,
                      ),
                      Transform.rotate(
                        angle: -45 * math.pi / 180,
                        child: const Icon(
                          Icons.arrow_upward,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }));
  }
}
