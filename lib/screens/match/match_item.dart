import 'package:canteen_frontend/models/message/message.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/shared_blocs/authentication/bloc.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/size_config.dart';
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
              left: constraints.maxWidth * 0.03,
              right: constraints.maxWidth * 0.03,
            ),
            decoration: BoxDecoration(
              color: Color(0xFFF0F0F0),
              border: Border.all(width: 0.5, color: Colors.grey[400]),
            ),
            child: Row(
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: ProfilePicture(
                    photoUrl: opponentList[0].photoUrl,
                    editable: false,
                    size: constraints.maxHeight * 0.75,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.only(
                        top: constraints.maxHeight * 0.15,
                        bottom: constraints.maxHeight * 0.15,
                        left: constraints.maxWidth * 0.04,
                        right: constraints.maxWidth * 0.04),
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
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            match.lastMessage != null
                                ? (match.lastMessage as TextMessage).text
                                : '',
                            style: TextStyle(color: Colors.grey[600]),
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.instance.blockSizeVertical * 2),
                    child: Column(
                      children: <Widget>[
                        Text(formatTime(match.lastUpdated)),
                      ],
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
