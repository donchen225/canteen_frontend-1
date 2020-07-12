import 'package:canteen_frontend/models/skill/skill.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog extends StatefulWidget {
  final User user;
  final Skill skill;
  final Function onConfirm;

  ConfirmationDialog(
      {@required this.user, @required this.skill, @required this.onConfirm});

  State<ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  final commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curentUserId =
        CachedSharedPreferences.getString(PreferenceConstants.userId);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            padding: EdgeInsets.only(
              top: SizeConfig.instance.blockSizeVertical * 3,
              bottom: SizeConfig.instance.blockSizeVertical * 3,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                  child: Text(
                    widget.user.displayName ?? '',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.instance.blockSizeVertical * 3),
                      child: ProfilePicture(
                        photoUrl: widget.user.photoUrl,
                        editable: false,
                        size: SizeConfig.instance.blockSizeHorizontal * 60,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(
                    bottom: SizeConfig.instance.blockSizeVertical * 3,
                    left: SizeConfig.instance.blockSizeHorizontal * 6,
                    right: SizeConfig.instance.blockSizeHorizontal * 6,
                  ),
                  child: Text(
                    '${widget.skill.name} - \$${widget.skill.price}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: SizeConfig.instance.blockSizeHorizontal * 3,
                    right: SizeConfig.instance.blockSizeHorizontal * 3,
                  ),
                  margin: EdgeInsets.only(
                    left: SizeConfig.instance.blockSizeHorizontal * 6,
                    right: SizeConfig.instance.blockSizeHorizontal * 6,
                    bottom: SizeConfig.instance.blockSizeVertical,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 1, color: Palette.borderSeparatorColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: commentController,
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        decoration: TextDecoration.none),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Write a message",
                      counterText: "",
                    ),
                    maxLength: 100,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: SizeConfig.instance.safeBlockHorizontal * 50,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        elevation: 0,
                        color: Colors.red[200],
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        child: Text('Send Request',
                            style: TextStyle(fontSize: 14)),
                        onPressed: curentUserId != widget.user.id
                            ? () {
                                widget.onConfirm(commentController.text);
                                Navigator.of(context).pop();
                              }
                            : null,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      color: Colors.transparent,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      child: Text('Cancel', style: TextStyle(fontSize: 14)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
