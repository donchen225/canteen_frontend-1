import 'dart:async';

import 'package:canteen_frontend/components/view_user_profile_screen.dart';
import 'package:canteen_frontend/models/arguments.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/search/arguments.dart';
import 'package:canteen_frontend/screens/search/search_bar.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:canteen_frontend/screens/search/search_result_item.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchingScreenDialog extends StatefulWidget {
  static const routeName = '/search';

  SearchingScreenDialog();

  @override
  _SearchingScreenDialogState createState() => _SearchingScreenDialogState();
}

class _SearchingScreenDialogState extends State<SearchingScreenDialog> {
  SearchBloc _searchBloc;
  TextEditingController _searchController;
  Timer _debounce;
  String _previousQuery;
  Key _key;

  @override
  void initState() {
    super.initState();

    _searchBloc = BlocProvider.of<SearchBloc>(context);
    _searchController = TextEditingController();

    _searchController.addListener(_startSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _startSearch() {
    if (_previousQuery != null &&
        _previousQuery.isNotEmpty &&
        _searchController.text.isEmpty) {
      _searchBloc.add(ResetSearch());
      _previousQuery = '';
    } else {
      if (_debounce?.isActive ?? false) _debounce.cancel();
      _debounce = Timer(
        const Duration(milliseconds: 300),
        () {
          final state = _searchBloc.state;

          if ((state is SearchCompleteShowResults &&
                  state.query == _searchController.text) ||
              (_searchController.text == _previousQuery) ||
              _searchController.text.isEmpty) {
            return;
          }

          _searchBloc.add(
            SearchStarted(
              query: _searchController.text,
              saveQuery: false,
              fromPreviousSearch: false,
            ),
          );

          _previousQuery = _searchController.text;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.bodyText2;

    return Scaffold(
      key: _key,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(SizeConfig.instance.appBarHeight),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Palette.appBarBackgroundColor,
          elevation: 1,
          flexibleSpace: SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final height = SizeConfig.instance.appBarHeight *
                    SizeConfig.instance.searchBarHeightRatio;

                return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                    left: constraints.maxWidth * 0.05,
                    right: constraints.maxWidth * 0.05,
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: SearchBar(
                          height: height,
                          color: Colors.grey[200],
                          child: TextField(
                            controller: _searchController,
                            autofocus: true,
                            autocorrect: false,
                            textInputAction: TextInputAction.search,
                            style: textTheme.apply(
                              fontSizeDelta: 1,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              hintText: "Search Users",
                              hintStyle: textTheme.apply(
                                color: Colors.grey[400],
                                fontSizeDelta: 1,
                              ),
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
        if (state is SearchCompleteShowResults) {
          final results = state.results;

          return _buildSearchResultsList(results);
        }

        return Container();
      }),
    );
  }

  Widget _buildSearchResultsList(List<User> results) {
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
              onTap: () {
                Navigator.maybePop(context, user);
              },
            ),
          );
        },
      ),
    );
  }
}
