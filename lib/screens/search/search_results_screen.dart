import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/search/search_bar.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchResultScreen extends StatelessWidget {
  final String query;
  final List<User> results;

  SearchResultScreen({this.query, this.results}) : assert(query != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        brightness: Brightness.light,
        backgroundColor: Palette.appBarBackgroundColor,
        elevation: 1,
        flexibleSpace: SafeArea(
          child: Align(
            alignment: Alignment.center,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final height = constraints.maxHeight * 0.7;
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth * 0.05,
                  ),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          BlocProvider.of<SearchBloc>(context)
                              .add(EnterSearchQuery());
                        },
                      ),
                      Flexible(
                        child: GestureDetector(
                          onTap: () {
                            BlocProvider.of<SearchBloc>(context)
                                .add(EnterSearchQuery(initialQuery: query));
                          },
                          child: SearchBar(
                            height: height,
                            color: Colors.grey[200],
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                query,
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
                );
              },
            ),
          ),
        ),
      ),
      body: Text('results'),
    );
  }
}
