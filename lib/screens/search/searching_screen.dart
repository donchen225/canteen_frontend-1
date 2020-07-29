import 'dart:async';

import 'package:canteen_frontend/screens/search/arguments.dart';
import 'package:canteen_frontend/screens/search/search_bar.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:canteen_frontend/screens/search/search_result_item.dart';
import 'package:canteen_frontend/screens/search/search_results_screen.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:math' as math;

class SearchingScreen extends StatefulWidget {
  final String initialQuery;
  static const routeName = '/search';

  SearchingScreen({this.initialQuery});

  @override
  _SearchingScreenState createState() => _SearchingScreenState();
}

class _SearchingScreenState extends State<SearchingScreen> {
  SearchBloc _searchBloc;
  TextEditingController _searchController;
  Timer _debounce;
  String _previousQuery;

  @override
  void initState() {
    super.initState();

    _searchBloc = BlocProvider.of<SearchBloc>(context);
    _searchController = TextEditingController();

    _searchController.text = widget.initialQuery ?? '';
    _searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: _searchController.text.length));

    _searchController.addListener(_startSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _startSearch() {
    if (_searchController.text != _previousQuery) {
      if (_debounce?.isActive ?? false) _debounce.cancel();
      _debounce = Timer(
        const Duration(milliseconds: 300),
        () {
          if (_searchController.text.isNotEmpty) {
            _searchBloc.add(
              SearchStarted(
                query: _searchController.text,
                saveQuery: false,
                fromPreviousSearch: false,
              ),
            );
          } else {
            // TODO: fix this being called multiple times
            if (_previousQuery != null &&
                _previousQuery.isNotEmpty &&
                _searchController.text.isEmpty) {
              _searchBloc.add(ResetSearch());
            }
          }

          _previousQuery = _searchController.text;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                              BlocProvider.of<SearchBloc>(context).add(
                                SearchStarted(
                                  query: query,
                                  saveQuery: true,
                                  fromPreviousSearch: false,
                                ),
                              );
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
                          _searchBloc.add(ResetSearch());
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
      body: BlocBuilder<SearchBloc, SearchState>(
          builder: (BuildContext context, SearchState state) {
        if (state is SearchUninitialized) {
          final searchHistory = _searchBloc.searchHistory
              .map((q) => q.displayQuery)
              .toList()
              .reversed
              .toList();

          return ListView.builder(
            itemCount: searchHistory.length,
            itemBuilder: (BuildContext context, int index) {
              final query = searchHistory[index];
              return GestureDetector(
                onTap: () {
                  BlocProvider.of<SearchBloc>(context).add(
                    SearchStarted(
                      query: query,
                      saveQuery: true,
                      fromPreviousSearch: true,
                    ),
                  );
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
            },
          );
        }

        if (state is SearchCompleteShowResults) {
          final results = state.results;

          if (results.isEmpty) {
            return Container(
              padding: EdgeInsets.only(
                left: SizeConfig.instance.safeBlockHorizontal * 6,
                right: SizeConfig.instance.safeBlockHorizontal * 6,
                top: SizeConfig.instance.safeBlockVertical * 2,
                bottom: SizeConfig.instance.safeBlockVertical * 2,
              ),
              child: Text(
                'No results found',
                style: Theme.of(context).textTheme.bodyText2.apply(
                      fontWeightDelta: 2,
                      color: Palette.textSecondaryBaseColor,
                    ),
              ),
            );
          }

          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollNotification) {
              if (scrollNotification is ScrollStartNotification) {
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              }

              return true;
            },
            child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (BuildContext context, int index) {
                final user = results[index];
                return Visibility(
                  visible: user.displayName != null,
                  child: SearchResultItem(
                    user: user,
                    showFullResult: false,
                  ),
                );
              },
            ),
          );
        }

        return Container();
      }),
    );
  }
}
