import 'package:canteen_frontend/models/request/request.dart';
import 'package:canteen_frontend/components/profile_list.dart';
import 'package:canteen_frontend/screens/recommended/bloc/bloc.dart';
import 'package:canteen_frontend/screens/recommended/recommended_empty_screen.dart';
import 'package:canteen_frontend/screens/recommended/recommended_unavailable.dart';
import 'package:canteen_frontend/screens/recommended/skip_user_button.dart';
import 'package:canteen_frontend/screens/request/request_bloc/bloc.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecommendedScreen extends StatefulWidget {
  RecommendedScreen();

  _RecommendedScreenState createState() => _RecommendedScreenState();
}

class _RecommendedScreenState extends State<RecommendedScreen> {
  Widget _getRecommendedWidget(RecommendedState state) {
    if (state is RecommendedLoaded) {
      final user = state.user;
      return Scaffold(
        key: UniqueKey(),
        floatingActionButton: SkipUserFloatingActionButton(
          onTap: () {
            BlocProvider.of<RecommendedBloc>(context).add(NextRecommended());
          },
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
                height: SizeConfig.instance.blockSizeHorizontal * 33,
                onTapLearnFunction: (skill) {
                  BlocProvider.of<RequestBloc>(context).add(
                    AddRequest(
                      Request.create(
                        skill: skill,
                        receiverId: user.id,
                      ),
                    ),
                  );

                  BlocProvider.of<RecommendedBloc>(context)
                      .add(AcceptRecommended());
                },
                onTapTeachFunction: (skill) {
                  BlocProvider.of<RequestBloc>(context).add(
                    AddRequest(
                      Request.create(
                        skill: skill,
                        receiverId: user.id,
                      ),
                    ),
                  );

                  BlocProvider.of<RecommendedBloc>(context)
                      .add(AcceptRecommended());
                },
              ),
            ),
          ]),
        ),
      );
    } else if (state is RecommendedEmpty) {
      return RecommendedEmptyScreen();
    } else if (state is RecommendedUnavailable) {
      return RecommendedUnavailableScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecommendedBloc, RecommendedState>(
      builder: (context, state) {
        if (state is RecommendedLoading) {
          return Center(child: CupertinoActivityIndicator());
        } else {
          return AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            switchOutCurve: Threshold(0),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.5, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
            child: _getRecommendedWidget(state),
          );
        }
      },
    );
  }
}
