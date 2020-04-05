import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/screens/prospect_profile/bloc/bloc.dart';
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
                print('Clicked');
              },
            ),
            body: ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ProfilePicture(
                      photoUrl: user.photoUrl,
                      localPicture:
                          AssetImage('assets/blank-profile-picture.jpeg'),
                      editable: false,
                      size: 160,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'About',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    user.about ?? '',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'I am teaching',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'I am learning',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
