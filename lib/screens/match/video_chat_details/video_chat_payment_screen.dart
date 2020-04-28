import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/models/match/match.dart';
import 'package:canteen_frontend/models/video_chat_date/video_chat_date.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

import 'video_chat_details_selection_screen.dart';

class VideoChatPaymentScreen extends StatelessWidget {
  final User user;
  final Match match;

  VideoChatPaymentScreen({
    @required this.user,
    @required this.match,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: SizeConfig.instance.blockSizeHorizontal * 3,
                      right: SizeConfig.instance.blockSizeHorizontal * 3,
                      top: SizeConfig.instance.blockSizeVertical * 3,
                      bottom: SizeConfig.instance.blockSizeVertical * 3,
                    ),
                    child: Text(
                      'Select method to pay:',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                VideoChatDetailsSelectionBlock(
                    user: user,
                    onSubmit: (List<VideoChatDate> proposedDates) {
                      // BlocProvider.of<VideoChatDetailsBloc>(context).add(
                      //   ProposeVideoChatDates(
                      //     matchId: matchId,
                      //     videoChatId: videoChatId,
                      //     dates: proposedDates,
                      //   ),
                      // );
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
