import 'package:canteen_frontend/models/match/status.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/match/match_bloc/bloc.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/screens/prospect_profile/bloc/bloc.dart';
import 'package:canteen_frontend/models/match/match.dart';
import 'package:canteen_frontend/screens/search/search_bloc/bloc.dart';
import 'package:canteen_frontend/shared_blocs/authentication/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfirmProspectScreen extends StatefulWidget {
  final User user;

  ConfirmProspectScreen(this.user);

  State<ConfirmProspectScreen> createState() => _ConfirmProspectScreenState();
}

class _ConfirmProspectScreenState extends State<ConfirmProspectScreen> {
  ProspectProfileBloc _prospectProfileBloc;

  @override
  void initState() {
    super.initState();

    _prospectProfileBloc = BlocProvider.of<ProspectProfileBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Text(
            widget.user.displayName ?? '',
            style: TextStyle(fontSize: 30),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: ProfilePicture(
                  photoUrl: widget.user.photoUrl,
                  localPicture: AssetImage('assets/blank-profile-picture.jpeg'),
                  editable: false,
                  size: 160,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 200,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red)),
                  elevation: 0,
                  color: Colors.red[200],
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  child: Text('Send Request', style: TextStyle(fontSize: 14)),
                  onPressed: () {
                    final currentUserId =
                        (BlocProvider.of<AuthenticationBloc>(context).state
                                as Authenticated)
                            .user
                            .uid;
                    BlocProvider.of<MatchBloc>(context).add(
                      AddMatch(
                        Match(
                          userId: {
                            currentUserId: 1,
                            widget.user.id: 0,
                          },
                          status: MatchStatus.initialized,
                        ),
                      ),
                    );

                    // TODO: show previous search results instead of redoing search
                    BlocProvider.of<SearchBloc>(context).add(SearchStarted(''));
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                elevation: 0,
                color: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent,
                child: Text('Cancel', style: TextStyle(fontSize: 14)),
                onPressed: () {
                  _prospectProfileBloc.add(LoadProspectProfile(widget.user));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
