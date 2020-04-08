import 'package:canteen_frontend/models/match/status.dart';
import 'package:canteen_frontend/models/request/request.dart';
import 'package:canteen_frontend/models/request/status.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/match/match_bloc/bloc.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/screens/profile/profile_section_title.dart';
import 'package:canteen_frontend/screens/profile/skill_list.dart';
import 'package:canteen_frontend/screens/prospect_profile/bloc/bloc.dart';
import 'package:canteen_frontend/models/match/match.dart';
import 'package:canteen_frontend/screens/request/bloc/bloc.dart';
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
    final currentUserId =
        (BlocProvider.of<AuthenticationBloc>(context).state as Authenticated)
            .user
            .uid;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.only(top: 80, left: 40, right: 40, bottom: 80),
        children: <Widget>[
          Center(
            child: Text(
              widget.user.displayName ?? '',
              style: TextStyle(fontSize: 30),
            ),
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
          ProfileSectionTitle("I'm teaching"),
          SkillList(
            widget.user.teachSkill,
            height: 50,
            showDescription: false,
          ),
          ProfileSectionTitle("I'm learning"),
          SkillList(
            widget.user.learnSkill,
            height: 50,
            showDescription: false,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 200,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  elevation: 0,
                  color: Colors.red[200],
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  child: Text('Send Request', style: TextStyle(fontSize: 14)),
                  onPressed: currentUserId != widget.user.id
                      ? () {
                          // TODO: add selected skill and comment
                          BlocProvider.of<RequestBloc>(context).add(
                            AddRequest(
                              Request(
                                sender: currentUserId,
                                receiver: widget.user.id,
                                status: RequestStatus.initialized,
                              ),
                            ),
                          );

                          // TODO: show previous search results instead of redoing search
                          BlocProvider.of<SearchBloc>(context)
                              .add(SearchStarted(''));
                        }
                      : null,
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
