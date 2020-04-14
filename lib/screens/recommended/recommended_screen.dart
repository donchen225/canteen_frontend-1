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
          return Scaffold(
            body: Center(
              child: Text('LOADING'),
            ),
          );
        }
      },
    );
  }
}
