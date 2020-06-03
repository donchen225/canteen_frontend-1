import 'package:canteen_frontend/components/interest_item.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/screens/profile/skill_list.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class ProfileList extends StatefulWidget {
  final User user;
  final double skillListHeight;
  final EdgeInsetsGeometry horizontalPadding;
  final Key key;
  final Function onTapTeachFunction;
  final Function onTapLearnFunction;

  ProfileList(
    this.user, {
    @required this.skillListHeight,
    this.horizontalPadding = const EdgeInsets.all(0),
    this.onTapTeachFunction,
    this.onTapLearnFunction,
    this.key,
  }) : super(key: key);

  @override
  _ProfileListState createState() => _ProfileListState();
}

class _ProfileListState extends State<ProfileList>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  final List<Text> tabChoices = [
    Text('Offerings',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        )),
    Text('Details',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        )),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabChoices.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          Padding(
            padding: widget.horizontalPadding,
            child: Container(
              height: SizeConfig.instance.safeBlockHorizontal * 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ProfilePicture(
                    photoUrl: widget.user.photoUrl,
                    shape: BoxShape.circle,
                    editable: false,
                    size: SizeConfig.instance.safeBlockHorizontal * 30,
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              SizeConfig.instance.safeBlockHorizontal * 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                              bottom:
                                  SizeConfig.instance.safeBlockVertical * 0.5,
                            ),
                            child: Text(
                              widget.user.displayName,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .apply(fontWeightDelta: 2),
                            ),
                          ),
                          Text(
                            widget.user.title ?? '',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Visibility(
                  visible: widget.user.interests?.isNotEmpty ?? false,
                  child: Align(
                    alignment: Alignment.center,
                    child: Wrap(
                        children: widget.user.interests
                                ?.map((x) => Padding(
                                      padding: EdgeInsets.only(
                                          right: SizeConfig.instance
                                                  .blockSizeHorizontal *
                                              3),
                                      child: InterestItem(text: x),
                                    ))
                                ?.toList() ??
                            []),
                  )),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.instance.safeBlockVertical,
                ),
                child: Text(widget.user.about ?? ''),
              ),
              Container(
                height: SizeConfig.instance.safeBlockVertical * 6,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      width: 0.5,
                      color: Colors.grey[400],
                    ),
                    bottom: BorderSide(
                      width: 0.5,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  tabs: tabChoices.map((text) => Tab(child: text)).toList(),
                ),
              ),
              Container(
                width: SizeConfig.instance.safeBlockHorizontal,
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    SkillList(
                      widget.user.teachSkill,
                      onTapExtraButton: widget.onTapTeachFunction,
                      height: widget.skillListHeight,
                    ),
                    Container(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
