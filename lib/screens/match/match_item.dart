import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_frontend/models/message/message.dart';
import 'package:canteen_frontend/shared_blocs/authentication/bloc.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:canteen_frontend/models/match/match.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchItem extends StatelessWidget {
  final GestureTapCallback onTap;
  final DetailedMatch match;

  MatchItem({Key key, @required this.onTap, @required this.match})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user =
        (BlocProvider.of<AuthenticationBloc>(context).state as Authenticated)
            .user;
    final opponentList = match.userList.where((u) => u.id != user.uid).toList();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: SizeConfig.instance.blockSizeVertical * 16,
        padding: EdgeInsets.only(
          top: SizeConfig.instance.blockSizeVertical * 2,
          bottom: SizeConfig.instance.blockSizeVertical * 2,
          left: SizeConfig.instance.blockSizeHorizontal * 6,
          right: SizeConfig.instance.blockSizeHorizontal * 6,
        ),
        decoration: BoxDecoration(
          color: Color(0xFFF0F0F0),
          border: Border.all(width: 1, color: Colors.grey[400]),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: SizeConfig.instance.blockSizeHorizontal * 20,
              height: SizeConfig.instance.blockSizeHorizontal * 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: (opponentList[0].photoUrl != null &&
                          opponentList[0].photoUrl.isNotEmpty)
                      ? CachedNetworkImageProvider(opponentList[0].photoUrl)
                      : AssetImage('assets/blank-profile-picture.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  left: SizeConfig.instance.blockSizeHorizontal * 3,
                  right: SizeConfig.instance.blockSizeHorizontal * 6),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Center(
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
            )
          ],
        ),
      ),
    );
  }
}
