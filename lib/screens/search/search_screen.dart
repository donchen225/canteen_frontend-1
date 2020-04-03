import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:canteen_frontend/screens/search/search_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatelessWidget {
  final UserRepository _userRepository;

  SearchScreen({@required UserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Search'),
        ),
        body: BlocListener<SearchBloc, SearchState>(
          listener: (context, state) {},
          child: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              print('IN SEARCH SCREEN');
              if (state is SearchShowProfile) {
                return Scaffold(
                  body: Center(
                    child: Text('PROFILE SCREEN'),
                  ),
                );
              } else {
                return SearchForm(userRepository: _userRepository);
              }
            },
          ),
        ));
  }
}
