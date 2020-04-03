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
      body: BlocProvider<SearchBloc>(
        create: (context) => SearchBloc(userRepository: _userRepository),
        child: SearchForm(userRepository: _userRepository),
      ),
    );
  }
}
