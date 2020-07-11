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
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                  top: kToolbarHeight * 0.15,
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
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                      Flexible(
                        child: GestureDetector(
                          onTap: () {
                            final searchHistory =
                                BlocProvider.of<SearchBloc>(context)
                                    .searchHistory;
                            // TODO: change to fade transition
                            Navigator.pushNamed(
                              context,
                              SearchingScreen.routeName,
                              arguments: SearchArguments(
                                initialQuery: widget.query,
                                searchHistory: searchHistory
                                    .map((q) => q.displayQuery)
                                    .toList()
                                    .reversed
                                    .toList(),
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
                ),
              );
            },
          ),
        ),
        // bottom: TabBar(
        //   indicatorSize: TabBarIndicatorSize.label,
        //   controller: _tabController,
        //   labelColor: Palette.primaryColor,
        //   unselectedLabelColor: Palette.appBarTextColor,
        //   labelStyle: Theme.of(context).textTheme.headline6,
        //   tabs: tabChoices.map((text) {
        //     return Padding(
        //       padding: EdgeInsets.symmetric(
        //         horizontal: kTabBarTextPadding,
        //       ),
        //       child: Tab(
        //         text: text,
        //       ),
        //     );
        //   }).toList(),
        // ),
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
                    height: SizeConfig.instance.safeBlockVertical * 14,
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
