import 'package:canteen_frontend/screens/search/arguments.dart';
import 'package:canteen_frontend/screens/search/search_bar.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:canteen_frontend/screens/search/search_result_item.dart';
import 'package:canteen_frontend/screens/search/searching_screen.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchResultScreen extends StatefulWidget {
  final String query;
  static const routeName = '/results';

  SearchResultScreen({this.query}) : assert(query != null);

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
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (BuildContext context, SearchState state) {
          if (state is SearchCompleteShowResults) {
            final results = state.results;

            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (BuildContext context, int index) {
                final user = results[index];
                return Visibility(
                  visible: user.displayName != null,
                  child: SearchResultItem(
                    user: user,
                  ),
                );
              },
            );
          }

          return Center(
            child: CupertinoActivityIndicator(),
          );
        },
      ),
    );
  }
}
