import 'package:canteen_frontend/models/message/message.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/shared_blocs/authentication/bloc.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:canteen_frontend/models/match/match.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

class MatchItem extends StatelessWidget {
  final GestureTapCallback onTap;
  final DetailedMatch match;

  MatchItem({Key key, @required this.onTap, @required this.match})
      : super(key: key);

  String formatTime(DateTime time) {
    String t = timeago
        .format(time, locale: 'en_short')
        .replaceFirst(' ', '')
        .replaceFirst('~', '')
        .replaceFirst('min', 'm');

    return t == 'now' ? t : '$t ago';
  }

  @override
  Widget build(BuildContext context) {
    final user =
        (BlocProvider.of<AuthenticationBloc>(context).state as Authenticated)
            .user;
    final opponentList = match.userList.where((u) => u.id != user.uid).toList();

    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: kMatchItemAspectRatio,
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            padding: EdgeInsets.only(
              top: constraints.maxHeight * 0.05,
              bottom: constraints.maxHeight * 0.05,
              left: constraints.maxWidth * 0.05,
              right: constraints.maxWidth * 0.03,
            ),
            decoration: BoxDecoration(
              color: Palette.containerColor,
              border: Border.all(width: 0.2, color: Colors.grey[400]),
            ),
            child: Stack(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    ProfilePicture(
                      photoUrl: opponentList[0].photoUrl,
                      editable: false,
                      size: constraints.maxHeight * 0.75,
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(
                            top: constraints.maxHeight * 0.15,
                            bottom: constraints.maxHeight * 0.15,
                            left: constraints.maxWidth * 0.04,
                            right: constraints.maxWidth * 0.02),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  opponentList[0].displayName ?? '',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: constraints.maxHeight * 0.18),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                match.lastMessage != null
                                    ? (match.lastMessage as TextMessage).text
                                    : '',
                                style: Theme.of(context).textTheme.bodyText1,
                                // style: TextStyle(
                                //     color: Colors.grey[600],
                                //     fontSize: constraints.maxHeight * 0.14),
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: constraints.maxHeight * 0.1,
                    horizontal: constraints.maxWidth * 0.05,
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      formatTime(match.lastUpdated),
                    ),
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
