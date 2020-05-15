import 'package:canteen_frontend/screens/search/discover_screen.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:canteen_frontend/screens/search/searching_screen.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
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
      return SearchingScreen();
    } else if (state is SearchCompleteShowResults) {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return Center(child: CupertinoActivityIndicator());
        } else {
          return AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            switchOutCurve: Threshold(0),
            child: _loadSearchWidget(context, state),
          );
        }
      },
    );
  }
}

// onTapDown: (_) {
//   FocusScopeNode currentFocus = FocusScope.of(context);

//   if (!currentFocus.hasPrimaryFocus) {
//     currentFocus.unfocus();
//   }
// },
