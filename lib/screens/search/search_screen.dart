import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/prospect_profile/prospect_profile_screen.dart';
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
    return BlocListener<SearchBloc, SearchState>(
      listener: (context, state) {},
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          print('IN SEARCH SCREEN');
          return AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            switchOutCurve: Threshold(0),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.25, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
            child: state is SearchShowProfile
                ? ProspectProfileScreen()
                : SearchForm(userRepository: _userRepository),
          );
        },
      ),
    );
  }
}
