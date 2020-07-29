import 'package:canteen_frontend/components/view_user_profile_screen.dart';
import 'package:canteen_frontend/models/arguments.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class SearchResultItem extends StatelessWidget {
  final User user;
  final bool showFullResult;

  SearchResultItem({this.user, this.showFullResult = true})
      : assert(user != null);

  @override
  Widget build(BuildContext context) {
    final nameStyle = Theme.of(context).textTheme.subtitle1;
    final bodyTextStyle = Theme.of(context).textTheme.bodyText2;
    final height = showFullResult
        ? SizeConfig.instance.safeBlockVertical * 14
        : SizeConfig.instance.safeBlockVertical * 8;

    return GestureDetector(
      onTap: () {
        if (user != null) {
          Navigator.pushNamed(
            context,
            ViewUserProfileScreen.routeName,
            arguments: UserArguments(
              user: user,
            ),
          );
        }
      },
      child: Container(
        height: height,
        decoration: BoxDecoration(
            color: Palette.containerColor,
            border: Border(
              top: BorderSide(
                width: 0.5,
                color: Colors.grey[300],
              ),
              bottom: BorderSide(
                width: 0.5,
                color: Colors.grey[300],
              ),
            )),
        padding: EdgeInsets.only(
          left: SizeConfig.instance.safeBlockHorizontal * 6,
          right: SizeConfig.instance.safeBlockHorizontal * 6,
          top: height * 0.1,
          bottom: height * 0.1,
        ),
        child: Row(
          crossAxisAlignment: showFullResult
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: <Widget>[
            ProfilePicture(
              photoUrl: user.photoUrl,
              editable: false,
              size: height * 0.6,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.instance.safeBlockHorizontal * 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: showFullResult
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      user.displayName,
                      style: nameStyle.apply(fontWeightDelta: 2),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Visibility(
                      visible: user.title?.isNotEmpty ?? false,
                      child: Text(
                        user.title ?? '',
                        style: nameStyle.apply(
                            color: Palette.textSecondaryBaseColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Visibility(
                      visible:
                          showFullResult && (user.about?.isNotEmpty ?? false),
                      child: Text(
                        user.about ?? '',
                        style: bodyTextStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
