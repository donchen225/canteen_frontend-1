import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/models/match/match.dart';
import 'package:canteen_frontend/models/video_chat_date/video_chat_date.dart';
import 'package:canteen_frontend/screens/match/match_detail_bloc/bloc.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MatchPaymentConfirmationScreen extends StatelessWidget {
  final User user;
  final Match match;
  final Skill skill;
  // final VideoChatDate date;

  MatchPaymentConfirmationScreen({
    @required this.user,
    @required this.match,
    @required this.skill,
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
                        // Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: IconButton(
                        //     icon: Icon(
                        //       Icons.arrow_back,
                        //     ),
                        //     onPressed: () {
                        //       // BlocProvider.of<MatchDetailBloc>(context)
                        //       //     .add(SelectEvent());
                        //     },
                        //   ),
                        // ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Confirm Payment',
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
                // top: SizeConfig.instance.blockSizeVertical * 3,
                bottom: SizeConfig.instance.blockSizeVertical * 3,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: SizeConfig.instance.blockSizeVertical * 6),
                    child: Container(
                      width: SizeConfig.instance.blockSizeHorizontal * 66,
                      padding: EdgeInsets.only(
                        left: SizeConfig.instance.blockSizeHorizontal * 6,
                        right: SizeConfig.instance.blockSizeHorizontal * 6,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                              top: SizeConfig.instance.blockSizeVertical * 3,
                              bottom: SizeConfig.instance.blockSizeVertical * 3,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                    'Video Chat (${skill.duration.toString()} min)'),
                                Text('\$ ${skill.price.toString()}'),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: SizeConfig.instance.blockSizeVertical * 3,
                              bottom: SizeConfig.instance.blockSizeVertical * 3,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Total'),
                                Text('\$ ${skill.price.toString()}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: RaisedButton(
                          padding: EdgeInsets.only(
                            top: SizeConfig.instance.blockSizeVertical * 2,
                            bottom: SizeConfig.instance.blockSizeVertical * 2,
                            left: SizeConfig.instance.blockSizeHorizontal * 6,
                            right: SizeConfig.instance.blockSizeHorizontal * 6,
                          ),
                          color: Palette.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'Complete payment',
                            style: TextStyle(
                                fontSize: 16,
                                color: Palette.whiteColor,
                                fontWeight: FontWeight.w600),
                          ),
                          onPressed: () {
                            BlocProvider.of<MatchDetailBloc>(context)
                                .add(ConfirmPayment(match: match));
                          },
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
