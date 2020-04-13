import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_frontend/models/message/message.dart';
import 'package:canteen_frontend/shared_blocs/authentication/bloc.dart';
import 'package:flutter/material.dart';
import 'package:canteen_frontend/models/match/match.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchItem extends StatelessWidget {
  final GestureTapCallback onTap;
  final DetailedMatch match;
  String displayMessage;

  MatchItem({Key key, @required this.onTap, @required this.match})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user =
        (BlocProvider.of<AuthenticationBloc>(context).state as Authenticated)
            .user;
    final opponentList = match.userList.where((u) => u.id != user.uid).toList();

    if (match.lastMessage is TextMessage) {
      displayMessage = (match.lastMessage as TextMessage).text;
      print(displayMessage);
    }

    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 50, // TODO: change this to be dynamic
        height: 50,
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
      title: Hero(
        tag: '${match.id}__heroTag',
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Text(
            opponentList[0].displayName ?? '',
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ),
      subtitle: Text(
        displayMessage ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.subhead,
      ),
    );
  }
}
