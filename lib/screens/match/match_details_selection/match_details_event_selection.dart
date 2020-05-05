import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/models/match/match.dart';
import 'package:canteen_frontend/models/video_chat_date/video_chat_date.dart';
import 'package:canteen_frontend/screens/match/match_detail_bloc/bloc.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchDetailEventSelectionScreen extends StatefulWidget {
  final User user;
  final Match match;

  MatchDetailEventSelectionScreen({
    @required this.user,
    @required this.match,
  });

  @override
  _MatchDetailEventSelectionScreenState createState() =>
      _MatchDetailEventSelectionScreenState();
}

class _MatchDetailEventSelectionScreenState
    extends State<MatchDetailEventSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: SizeConfig.instance.blockSizeVertical * 3),
                child: ProfilePicture(
                  photoUrl: widget.user.photoUrl,
                  editable: false,
                  size: SizeConfig.instance.blockSizeHorizontal * 50,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: SizeConfig.instance.blockSizeHorizontal * 3,
                right: SizeConfig.instance.blockSizeHorizontal * 3,
                top: SizeConfig.instance.blockSizeVertical * 3,
                bottom: SizeConfig.instance.blockSizeVertical * 3,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: RaisedButton(
                          child: Text('Continue'),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
