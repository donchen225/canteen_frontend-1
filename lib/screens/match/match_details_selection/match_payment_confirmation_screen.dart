import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/models/match/match.dart';
import 'package:canteen_frontend/models/video_chat_date/video_chat_date.dart';
import 'package:canteen_frontend/screens/match/match_detail_bloc/bloc.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MatchPaymentConfirmationScreen extends StatelessWidget {
  final User user;
  final Match match;
  // final VideoChatDate date;

  MatchPaymentConfirmationScreen({
    @required this.user,
    @required this.match,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
              height: SizeConfig.instance.blockSizeVertical * 10,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                            ),
                            onPressed: () {
                              // BlocProvider.of<MatchDetailBloc>(context)
                              //     .add(SelectEvent());
                            },
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Video Chat Session',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )),
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
                  Text('\$'),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Select method to pay:',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
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
