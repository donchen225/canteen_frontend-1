import 'package:canteen_frontend/screens/search/search_bar.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:math' as math;

class SearchingScreen extends StatefulWidget {
  final String initialQuery;
  final List<String> searchHistory;

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

    final textTheme = Theme.of(context).textTheme.subtitle1.apply(
          fontFamily: '.SF UI Text',
        );

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
                        Flexible(
                          child: SearchBar(
                            height: height,
                            color: Colors.grey[200],
                            child: TextField(
                              controller: _searchController,
                              autofocus: true,
                              textInputAction: TextInputAction.search,
                              textCapitalization: TextCapitalization.sentences,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                  bottom: constraints.maxHeight * 0.15,
                                ),
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
                              },
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            BlocProvider.of<SearchBloc>(context)
                                .add(SearchPreviousState());
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: height,
                            padding: EdgeInsets.only(
                              left: SizeConfig.instance.safeBlockHorizontal * 3,
                            ),
                            child: Text('Cancel', style: textTheme),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
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
