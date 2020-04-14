import 'package:canteen_frontend/screens/profile/profile_list.dart';
import 'package:canteen_frontend/screens/recommended/bloc/bloc.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
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
          return Center(child: CupertinoActivityIndicator());
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
            body: Container(
              color: Colors.grey[100],
              child: CustomScrollView(slivers: <Widget>[
                SliverAppBar(
                  pinned: true,
                  brightness: Brightness.light,
                  backgroundColor: Colors.grey[100],
                  title: Text(
                    user.displayName ?? '',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(
                      bottom: SizeConfig.instance.blockSizeVertical * 13,
                      left: SizeConfig.instance.blockSizeHorizontal * 3,
                      right: SizeConfig.instance.blockSizeHorizontal * 3),
                  sliver: ProfileList(
                    user,
                    height: SizeConfig.instance.blockSizeHorizontal * 30,
                  ),
                ),
              ]),
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
