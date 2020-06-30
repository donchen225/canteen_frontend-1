import 'package:canteen_frontend/models/request/request.dart';
import 'package:canteen_frontend/screens/match/match_item.dart';
import 'package:canteen_frontend/screens/request/arguments.dart';
import 'package:canteen_frontend/screens/request/view_user_request_screen.dart';
import 'package:flutter/material.dart';

class RequestList extends StatelessWidget {
  final List<DetailedRequest> items;
  final key;

  RequestList({@required this.items, this.key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final request = items[index];
        final user = request.sender;

        return MatchItem(
          displayName: user.displayName ?? '',
          photoUrl: user.photoUrl,
          message:
              "${user.displayName} sent you a request for ${request.skill} - \$${request.price.toStringAsFixed(2)}",
          time: request.createdOn,
          onTap: () => Navigator.pushNamed(
            context,
            ViewUserRequestScreen.routeName,
            arguments: RequestArguments(
              request: request,
              user: user,
            ),
          ),
        );
      },
    );
  }
}
