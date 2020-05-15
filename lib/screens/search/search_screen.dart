import 'package:canteen_frontend/screens/search/discover_screen.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:canteen_frontend/screens/search/search_results_screen.dart';
import 'package:canteen_frontend/screens/search/search_show_profile_screen.dart';
import 'package:canteen_frontend/screens/search/searching_screen.dart';
import 'package:canteen_frontend/screens/search/view_user_profile_screen.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);

  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
  }

  Widget _loadSearchWidget(BuildContext context, SearchState state) {
    if (state is SearchUninitialized) {
      return DiscoverScreen(state.allUsers);
    } else if (state is SearchTyping) {
      return SearchingScreen(
          initialQuery: state.initialQuery, searchHistory: state.searchHistory);
    } else if (state is SearchCompleteShowResults) {
      return SearchResultScreen(query: state.query, results: state.results);
    } else if (state is SearchShowProfile) {
      return ViewUserProfileScreen(
        user: state.user,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        print('STATE: $state');
        if (state is SearchLoading) {
          return Center(child: CupertinoActivityIndicator());
        } else {
          return AnimatedSwitcher(
            duration: Duration(milliseconds: animationDuration),
            switchOutCurve: Threshold(0),
            child: _loadSearchWidget(context, state),
            transitionBuilder: (Widget child, Animation<double> animation) {
              print('STATE: $state');
              if (state is SearchShowProfile) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(offsetdXForward, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              }

              if (state is SearchCompleteShowResults ||
                  state is SearchUninitialized) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(offsetdXReverse, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              }

              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          );
        }
      },
    );
  }
}
