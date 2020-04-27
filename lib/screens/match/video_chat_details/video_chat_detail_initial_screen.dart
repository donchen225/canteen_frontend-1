import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/models/video_chat_date/video_chat_date.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'video_chat_details_selection_screen.dart';

class VideoChatDetailInitialScreen extends StatelessWidget {
  final User user;
  final String matchId;
  final String videoChatId;

  VideoChatDetailInitialScreen(
      {@required this.user,
      @required this.matchId,
      @required this.videoChatId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        title: Text(
          user.displayName ?? user.email,
          style: GoogleFonts.montserrat(fontSize: 22, color: Colors.black),
        ),
        backgroundColor: Palette.appBarBackgroundColor,
        elevation: 1,
      ),
      body: Container(
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
                        'Select 3 times to video chat:',
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
      ),
    );
  }
}
