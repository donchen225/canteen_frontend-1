import 'package:canteen_frontend/models/request/request.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/match/match_item.dart';
import 'package:canteen_frontend/screens/request/arguments.dart';
import 'package:canteen_frontend/screens/request/view_user_request_screen.dart';
import 'package:flutter/material.dart';

class RequestList extends StatelessWidget {
  final List<DetailedRequest> items;
  final key;

  RequestList({@required this.items, this.key}) : super(key: key);

  String _buildRequestText(DetailedRequest request) {
    if (request is Referral) {
      return "${request.sender.displayName} asked you for a referral to connect with ${request.receiver.displayName} for ${request.skill} - \$${request.price.toStringAsFixed(2)}";
    } else if (request is ReferredRequest) {
      return "${request.referral.displayName} referred ${request.sender.displayName} to you for ${request.skill} - \$${request.price.toStringAsFixed(2)}";
    } else {
      return "Sent you a request for ${request.skill} - \$${request.price.toStringAsFixed(2)}";
    }
  }

  User _getAdditionalUser(DetailedRequest request) {}

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final request = items[index];
        final user = request.sender;
        User additionalUser;
        bool userDoesNotExist = false;

        if (request is Referral) {
          if (request.receiver == null) {
            userDoesNotExist = true;
          } else {
            additionalUser = request.receiver;
          }
        } else if (request is ReferredRequest) {
          if (request.referral == null) {
            userDoesNotExist = true;
          } else {
            additionalUser = request.referral;
          }
        }

        // Check if sender exists (deleted user), otherwise don't show
        if (user == null || userDoesNotExist) {
          return Container();
        }

        return MatchItem(
          displayName: user.displayName ?? '',
          photoUrl: user.photoUrl,
          additionalDisplayName: additionalUser?.displayName ?? '',
          additionalPhotoUrl: additionalUser != null
              ? (additionalUser.photoUrl != null ? additionalUser.photoUrl : '')
              : null,
          message: _buildRequestText(request),
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
