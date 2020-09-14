import 'package:canteen_frontend/components/group_picture.dart';
import 'package:canteen_frontend/models/group/group.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class GroupSummaryBlock extends StatelessWidget {
  const GroupSummaryBlock({
    Key key,
    @required this.group,
  }) : super(key: key);

  final Group group;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.containerColor,
      padding: EdgeInsets.only(
        top: SizeConfig.instance.safeBlockVertical * 2,
        left:
            SizeConfig.instance.safeBlockHorizontal * kHorizontalPaddingBlocks,
        right:
            SizeConfig.instance.safeBlockHorizontal * kHorizontalPaddingBlocks,
      ),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GroupPicture(
                photoUrl: group.photoUrl,
                shape: BoxShape.circle,
                size: kProfileSize,
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.instance.safeBlockHorizontal *
                          kHorizontalPaddingBlocks),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: [
                          Text(
                            '${group.members?.toString() ?? "0"}',
                            style: Theme.of(context).textTheme.bodyText2.apply(
                                  fontSizeDelta: 2,
                                  fontWeightDelta: 2,
                                ),
                          ),
                          Text(
                            'Members' ?? '',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '${group.posts?.toString() ?? "0"}',
                            style: Theme.of(context).textTheme.bodyText2.apply(
                                  fontSizeDelta: 2,
                                  fontWeightDelta: 2,
                                ),
                          ),
                          Text(
                            'Offers' ?? '',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '${group.posts?.toString() ?? "0"}',
                            style: Theme.of(context).textTheme.bodyText2.apply(
                                  fontSizeDelta: 2,
                                  fontWeightDelta: 2,
                                ),
                          ),
                          Text(
                            'Requests' ?? '',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: SizeConfig.instance.safeBlockVertical,
            ),
            child: Text(
              group.name,
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .apply(fontWeightDelta: 2),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(
              vertical: SizeConfig.instance.safeBlockVertical * 0.5,
            ),
            child: Text(
              group.description ?? '',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ],
      ),
    );
  }
}
