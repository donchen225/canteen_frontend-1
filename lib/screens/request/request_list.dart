import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_frontend/components/view_user_profile_screen.dart';
import 'package:canteen_frontend/models/arguments.dart';
import 'package:canteen_frontend/models/request/request.dart';
import 'package:canteen_frontend/screens/match/match_item.dart';
import 'package:canteen_frontend/screens/request/arguments.dart';
import 'package:canteen_frontend/screens/request/view_user_request_screen.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class RequestList extends StatelessWidget {
  final List<DetailedRequest> items;
  final key;

  RequestList({@required this.items, this.key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double itemHeight = SizeConfig.instance.safeBlockVertical / 2.5;
    final double itemWidth = SizeConfig.instance.safeBlockHorizontal / 2;

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
