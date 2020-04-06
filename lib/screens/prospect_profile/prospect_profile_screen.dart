import 'package:canteen_frontend/models/match/status.dart';
import 'package:canteen_frontend/screens/match/match_bloc/bloc.dart';
import 'package:canteen_frontend/screens/profile/profile_list.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/screens/prospect_profile/bloc/bloc.dart';
import 'package:canteen_frontend/models/match/match.dart';
import 'package:canteen_frontend/shared_blocs/authentication/bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProspectProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProspectProfileBloc, ProspectProfileState>(
      builder: (context, state) {
        if (state is ProspectProfileLoading) {
          print('PROSPECT PROFILE LOADING');
          return Center(child: CircularProgressIndicator());
        } else if (state is ProspectProfileLoaded) {
          final user = state.user;
          final currentUserId = (BlocProvider.of<AuthenticationBloc>(context)
                  .state as Authenticated)
              .user
              .uid;

          return Scaffold(
            appBar: AppBar(
              title: Text(user.displayName ?? ''),
            ),
            floatingActionButton: FloatingActionButton(
              foregroundColor: Colors.white,
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 5,
              child: Icon(Icons.message),
              onPressed: () {
                BlocProvider.of<MatchBloc>(context).add(
                  AddMatch(
                    Match(
                      userId: {
                        currentUserId: 1,
                        user.id: 0,
                      },
                      status: MatchStatus.initialized,
                    ),
                  ),
                );
              },
            ),
            body: ProfileList(user),
          );
        }
      },
    );
  }
}
