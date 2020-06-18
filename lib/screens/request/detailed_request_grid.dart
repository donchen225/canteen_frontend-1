import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_frontend/components/view_user_profile_screen.dart';
import 'package:canteen_frontend/models/arguments.dart';
import 'package:canteen_frontend/models/request/request.dart';
import 'package:canteen_frontend/screens/match/match_item.dart';
import 'package:canteen_frontend/screens/request/arguments.dart';
import 'package:canteen_frontend/screens/request/view_user_request_screen.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
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
          displayName: user.displayName,
          photoUrl: user.photoUrl,
          message:
              "${user.displayName} sent you a request for ${request.skill}",
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

    return Container(
      color: Palette.scaffoldBackgroundDarkColor,
      child: GridView.builder(
        padding: EdgeInsets.only(
          left: SizeConfig.instance.blockSizeHorizontal * 3,
          right: SizeConfig.instance.blockSizeHorizontal * 3,
          top: SizeConfig.instance.blockSizeVertical * 3,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: (itemWidth / itemHeight),
          crossAxisCount: 2,
          crossAxisSpacing: SizeConfig.instance.blockSizeHorizontal * 3,
          mainAxisSpacing: SizeConfig.instance.blockSizeVertical * 3,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final request = items[index];
          final user = request.sender;

          return GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              ViewUserProfileScreen.routeName,
              arguments: UserArguments(
                user: user,
              ),
            ),
            child: Card(
              elevation: 0.2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                        image: DecorationImage(
                          image: (user.photoUrl != null &&
                                  user.photoUrl.isNotEmpty)
                              ? CachedNetworkImageProvider(user.photoUrl)
                              : AssetImage('assets/blank-profile-picture.jpeg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: SizeConfig.instance.blockSizeVertical,
                          bottom: SizeConfig.instance.blockSizeVertical,
                          left: SizeConfig.instance.blockSizeHorizontal * 3,
                          right: SizeConfig.instance.blockSizeHorizontal * 3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                user.displayName ?? '',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: SizeConfig
                                            .instance.blockSizeHorizontal *
                                        4),
                              ),
                            ],
                          ),
                          Visibility(
                            visible: request.skill.isNotEmpty,
                            child: Container(
                                padding: EdgeInsets.only(
                                  top: SizeConfig.instance.blockSizeVertical,
                                  bottom: SizeConfig.instance.blockSizeVertical,
                                  left:
                                      SizeConfig.instance.blockSizeHorizontal *
                                          3,
                                  right:
                                      SizeConfig.instance.blockSizeHorizontal *
                                          3,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.lightBlueAccent[100],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Text(
                                  request.skill,
                                  overflow: TextOverflow.ellipsis,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
