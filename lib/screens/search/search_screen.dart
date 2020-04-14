import 'package:canteen_frontend/screens/prospect_profile/bloc/prospect_profile_bloc.dart';
import 'package:canteen_frontend/screens/prospect_profile/bloc/prospect_profile_event.dart';
import 'package:canteen_frontend/screens/prospect_profile/prospect_profile_screen.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:canteen_frontend/screens/search/search_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchBloc, SearchState>(
      listener: (context, state) {},
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          print('IN SEARCH SCREEN');
          print(state);
          return AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            switchOutCurve: Threshold(0),
            transitionBuilder: (Widget child, Animation<double> animation) {
              print('BUILDER');
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.25, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
            child: SearchForm(),
          );
        },
      ),
    );
  }
}
