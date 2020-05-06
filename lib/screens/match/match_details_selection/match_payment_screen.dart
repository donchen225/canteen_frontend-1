import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/models/match/match.dart';
import 'package:canteen_frontend/models/video_chat_date/video_chat_date.dart';
import 'package:canteen_frontend/screens/match/match_detail_bloc/bloc.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MatchPaymentScreen extends StatelessWidget {
  final User user;
  final Match match;
  final Skill skill;
  final VideoChatDate date;
  final DateFormat timeFormat = DateFormat.jm();

  MatchPaymentScreen({
    @required this.user,
    @required this.match,
    @required this.skill,
    @required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final endTime = date.startTime.add(Duration(seconds: date.duration * 60));

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
                        //       //     .add(ViewVideoChatDates());
                        //     },
                        //   ),
                        // ),
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.instance.blockSizeVertical),
                          child:
                              Text(skill.name, style: TextStyle(fontSize: 25)),
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  right:
                                      SizeConfig.instance.blockSizeHorizontal,
                                  top: SizeConfig.instance.blockSizeVertical,
                                  bottom:
                                      SizeConfig.instance.blockSizeVertical),
                              child: const Icon(IconData(0xf26e,
                                  fontFamily: CupertinoIcons.iconFont,
                                  fontPackage: CupertinoIcons.iconFontPackage)),
                            ),
                            Text('${date.duration.toString()} min'),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.instance.blockSizeVertical),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    right: SizeConfig
                                        .instance.blockSizeHorizontal),
                                child: const Icon(IconData(0xf2d1,
                                    fontFamily: CupertinoIcons.iconFont,
                                    fontPackage:
                                        CupertinoIcons.iconFontPackage)),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(DateFormat('yMMMMEEEEd')
                                      .format(date.startTime)),
                                  Text(
                                      '${timeFormat.format(date.startTime)} - ${timeFormat.format(endTime)} ${date.timeZone}'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Text('\$ ${skill.price.toString()}'),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Container(
                    child: Text(skill.description),
                  )),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Select method to pay:',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                              child: Text('Venmo'),
                            ),
                            Container(
                              child: Text('Paypal'),
                            ),
                            Container(
                              child: Text('Credit Card'),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: RaisedButton(
                                child: Text('Continue'),
                                onPressed: () {
                                  BlocProvider.of<MatchDetailBloc>(context).add(
                                      SelectPayment(
                                          skill: skill,
                                          paymentMethod:
                                              'Venmo')); //TODO: change this to real payment method
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
