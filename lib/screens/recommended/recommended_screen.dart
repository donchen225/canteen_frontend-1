import 'package:canteen_frontend/screens/profile/profile_list.dart';
import 'package:canteen_frontend/screens/recommended/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecommendedScreen extends StatefulWidget {
  RecommendedScreen();

  _RecommendedScreenState createState() => _RecommendedScreenState();
}

class _RecommendedScreenState extends State<RecommendedScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecommendedBloc, RecommendedState>(
      builder: (context, state) {
        if (state is RecommendedLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is RecommendedLoaded) {
          final user = state.user;
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                BlocProvider.of<RecommendedBloc>(context)
                    .add(NextRecommended());
              },
              child: Icon(Icons.clear),
            ),
            body: Padding(
              padding: EdgeInsets.only(top: 20),
              child: ProfileList(
                user,
                height: 100,
                showName: true,
              ),
            ),
          );
        } else if (state is RecommendedEmpty) {
          return Center(child: Text('OUT OF RECOMMENDATIONS'));
        } else if (state is RecommendedUnavailable) {
          return Center(child: Text('NO RECOMMENDATIONS AVAILABLE'));
        }
      },
    );
  }
}
