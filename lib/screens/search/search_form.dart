import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_frontend/screens/profile/profile_list.dart';
import 'package:canteen_frontend/screens/request/profile_grid.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchForm extends StatefulWidget {
  SearchForm({Key key}) : super(key: key);

  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  SearchBloc _searchBloc;

  @override
  void initState() {
    super.initState();
    _searchBloc = BlocProvider.of<SearchBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Container(
          height: 40,
          color: Colors.grey[300],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                  child: TextField(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.search,
                        size: 20,
                        color: Colors.grey[800],
                      ),
                      border: InputBorder.none,
                      hintText: "Search",
                    ),
                    onSubmitted: (query) {
                      print('SUBMITTED: $query');
                      BlocProvider.of<SearchBloc>(context)
                          .add(SearchStarted(query));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: GestureDetector(
        onTapDown: (_) {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            print('IN SEARCH FORM');
            if (state is SearchLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is SearchUninitialized) {
              return ProfileGrid(
                state.allUsers,
                onTap: (user) {
                  BlocProvider.of<SearchBloc>(context)
                      .add(SearchInspectUser(user));
                },
              );
            } else if (state is SearchShowProfile) {
              return ProfileList(
                state.user,
                height: 100,
                showName: true,
              );
            } else if (state is SearchCompleteNoResults) {
              return Center(
                child: Text(state.message),
              );
            }
          },
        ),
      ),
    );
  }
}
