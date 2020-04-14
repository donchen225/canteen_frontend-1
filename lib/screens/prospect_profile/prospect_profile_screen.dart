import 'package:canteen_frontend/screens/profile/profile_list.dart';
import 'package:canteen_frontend/screens/prospect_profile/bloc/bloc.dart';
import 'package:canteen_frontend/screens/prospect_profile/confirm_prospect_screen.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProspectProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProspectProfileBloc, ProspectProfileState>(
      builder: (context, state) {
        if (state is ProspectProfileLoading) {
          print('PROSPECT PROFILE LOADING');
          return Center(child: CupertinoActivityIndicator());
        } else if (state is ProspectProfileLoaded) {
          final user = state.user;

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
                BlocProvider.of<ProspectProfileBloc>(context)
                    .add(ConfirmProspectProfile(user));
              },
            ),
            body: ProfileList(
              user,
              height: 100,
            ),
          );
        } else if (state is ProspectProfileConfirmation) {
          return ConfirmProspectScreen(state.user);
        }
      },
    );
  }
}
