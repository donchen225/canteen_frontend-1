import 'package:canteen_frontend/screens/search/search_bar.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          brightness: Brightness.light,
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
                    top: kToolbarHeight * 0.18,
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
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.instance.safeBlockHorizontal * 6),
          child: ListView.builder(
              itemCount: widget.searchHistory.length,
              itemBuilder: (BuildContext context, int index) {
                final query = widget.searchHistory[index];
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.only(
                      top: SizeConfig.instance.safeBlockVertical,
                      bottom: SizeConfig.instance.safeBlockVertical,
                    ),
                    child: Text(
                      query,
                      style: textTheme,
                    ),
                  ),
                );
              }),
        ));
  }
}
