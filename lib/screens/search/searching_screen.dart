import 'package:canteen_frontend/screens/search/search_bar.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchingScreen extends StatefulWidget {
  @override
  _SearchingScreenState createState() => _SearchingScreenState();
}

class _SearchingScreenState extends State<SearchingScreen> {
  @override
  Widget build(BuildContext context) {
    final appBarTextTheme = Theme.of(context).textTheme.subtitle1.apply(
          fontFamily: '.SF UI Text',
        );

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
                      Flexible(
                        child: SearchBar(
                          height: height,
                          color: Colors.grey[200],
                          child: TextField(
                            autofocus: true,
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
                              hintStyle: appBarTextTheme.apply(
                                color: Colors.grey[400],
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          BlocProvider.of<SearchBloc>(context)
                              .add(SearchHome());
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: height,
                          padding: EdgeInsets.only(
                            left: SizeConfig.instance.safeBlockHorizontal * 3,
                          ),
                          child: Text('Cancel', style: appBarTextTheme),
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
    );
  }
}
