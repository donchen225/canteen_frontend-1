import 'package:canteen_frontend/components/view_user_profile_screen.dart';
import 'package:canteen_frontend/models/group/group_member.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/shared_blocs/profile_bloc/bloc.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MemberItem extends StatefulWidget {
  const MemberItem({
    Key key,
    @required this.member,
    @required this.itemHeight,
  }) : super(key: key);

  final GroupMember member;
  final double itemHeight;

  @override
  _MemberItemState createState() => _MemberItemState();
}

class _MemberItemState extends State<MemberItem> {
  bool _tapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _tapped = true;
        });
      },
      onTapCancel: () {
        setState(() {
          _tapped = false;
        });
      },
      onTap: () {
        BlocProvider.of<ProfileBloc>(context)
            .add(LoadProfile(widget.member.id));
        Navigator.pushNamed(
          context,
          ViewUserProfileScreen.routeName,
        );
        setState(() {
          _tapped = false;
        });
      },
      child: Container(
        height: widget.itemHeight,
        decoration: BoxDecoration(
          color: _tapped ? Palette.tabSelectedColor : Palette.whiteColor,
          border: Border(
            top: BorderSide(color: Palette.borderSeparatorColor, width: 0.25),
            bottom:
                BorderSide(color: Palette.borderSeparatorColor, width: 0.25),
          ),
        ),
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 2,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: widget.itemHeight * 0.2),
                child: ProfilePicture(
                  photoUrl: widget.member.photoUrl,
                  size: widget.itemHeight * 0.7,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(widget.member.name,
                      style: Theme.of(context).textTheme.headline6),
                  Padding(
                    padding: EdgeInsets.only(
                      top: widget.itemHeight * 0.03,
                      bottom: widget.itemHeight * 0.03,
                    ),
                    child: Text(
                      widget.member.title,
                      style: Theme.of(context).textTheme.subtitle1.apply(
                            color: Palette.textSecondaryBaseColor,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Palette.textSecondaryBaseColor,
                  size: 20,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
