import 'package:canteen_frontend/components/view_user_profile_screen.dart';
import 'package:canteen_frontend/models/arguments.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/search/arguments.dart';
import 'package:canteen_frontend/screens/search/search_bar.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:canteen_frontend/screens/search/search_result_item.dart';
import 'package:canteen_frontend/screens/search/searching_screen.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchResultScreen extends StatefulWidget {
  final String query;
  final List<User> results;
  static const routeName = '/results';

  SearchResultScreen({this.query, this.results}) : assert(query != null);

  @override
  _SearchResultScreenState createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen>
    with SingleTickerProviderStateMixin {
  List<User> _results;
  TabController _tabController;
  Key _key;

  final List<String> tabChoices = ['People', 'Groups'];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: tabChoices.length);
    _key = UniqueKey();

    _results = widget.results;

    if (_results == null) {
      BlocProvider.of<SearchBloc>(context).add(
        SearchStarted(
          query: widget.query,
          saveQuery: true,
          fromPreviousSearch: true,
        ),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      IconButton(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.arrow_back_ios),
                        constraints: BoxConstraints(
                          minHeight: height,
                          minWidth: height,
                        ),
                        onPressed: () {
                          final searchBloc =
                              BlocProvider.of<SearchBloc>(context);
                          final searchResultState = searchBloc.state;

                          if (searchResultState is SearchCompleteShowResults &&
                              searchResultState.fromPreviousSearch) {
                            searchBloc.add(ResetSearch());
                          } else {
                            if (widget.results != null) {
                              searchBloc.add(
                                ShowSearchResults(
                                  query: widget.query,
                                  results: widget.results,
                                ),
                              );
                            } else {
                              searchBloc.add(ResetSearch());
                            }
                          }

                          Navigator.of(context).maybePop();
                        },
                      ),
                      Flexible(
                        child: GestureDetector(
                          onTap: () {
                            // TODO: change to fade transition
                            Navigator.pushNamed(
                              context,
                              SearchingScreen.routeName,
                              arguments: SearchArguments(
                                initialQuery: widget.query,
                                isInitialSearch: false,
                              ),
                            );
                          },
                          child: SearchBar(
                            height: height,
                            color: Colors.grey[200],
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.query,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .apply(
                                        color: Palette.textSecondaryBaseColor),
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
      body: _buildSearchResults(),
    );
  }

  Widget _buildSearchResults() {
    if (_results != null) {
      return _buildSearchResultsList(_results);
    }

    return BlocBuilder<SearchBloc, SearchState>(
      builder: (BuildContext context, SearchState state) {
        if (state is SearchCompleteShowResults) {
          final results = state.results;
          _results = results;

          return _buildSearchResultsList(results);
        }

        return Center(child: CupertinoActivityIndicator());
      },
    );
  }

  ListView _buildSearchResultsList(List<User> results) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (BuildContext context, int index) {
        final user = results[index];
        return Visibility(
          visible: user.displayName != null,
          child: SearchResultItem(
            user: user,
            onTap: () {
              Navigator.pushNamed(
                context,
                ViewUserProfileScreen.routeName,
                arguments: UserArguments(
                  user: user,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
