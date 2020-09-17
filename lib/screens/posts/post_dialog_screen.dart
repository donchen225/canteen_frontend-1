import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/screens/posts/action_button.dart';
import 'package:canteen_frontend/screens/posts/text_dialog_screen.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/shared_blocs/user/user_bloc.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostDialogScreen extends StatefulWidget {
  final Function onConfirm;

  PostDialogScreen({@required this.onConfirm});

  @override
  _PostDialogScreenState createState() => _PostDialogScreenState();
}

class _PostDialogScreenState extends State<PostDialogScreen> {
  String postType;
  TextEditingController _messageController;

  _PostDialogScreenState();

  @override
  void initState() {
    super.initState();

    _messageController = TextEditingController();

    _messageController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = BlocProvider.of<UserBloc>(context).currentUser;

    return TextDialogScreen(
      title: 'New Post',
      canUnfocus: false,
      sendWidget: ActionButton(
          enabled: _messageController.text.isNotEmpty &&
              (postType == 'offer' || postType == 'request'),
          onTap: (BuildContext context) {
            if (_messageController.text.isNotEmpty) {
              final now = DateTime.now();
              final post = Post(
                message: _messageController.text,
                from: user.id,
                type: postType,
                createdOn: now,
                lastUpdated: now,
              );
              widget.onConfirm(post);
              Navigator.maybePop(context);
            } else {
              final snackBar = SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.white,
                duration: Duration(seconds: 2),
                content: Row(
                  children: <Widget>[
                    Container(
                      width: 10,
                      height: SizeConfig.instance.blockSizeVertical * 3,
                      color: Colors.red,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              SizeConfig.instance.blockSizeHorizontal * 3),
                      child: Text(
                        'Please enter your post',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              );
              Scaffold.of(context).showSnackBar(snackBar);
            }
          }),
      child: Padding(
        padding: EdgeInsets.only(
          left: SizeConfig.instance.blockSizeHorizontal * 6,
          right: SizeConfig.instance.blockSizeHorizontal * 6,
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                ProfilePicture(
                  photoUrl: user.photoUrl,
                  editable: false,
                  size: 40,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.instance.blockSizeHorizontal * 2),
                  child: Text(
                    '${user.displayName ?? ''}',
                    style: Theme.of(context).textTheme.bodyText1.apply(
                          fontWeightDelta: 2,
                        ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                top: SizeConfig.instance.safeBlockVertical,
              ),
              child: Row(
                children: [
                  FlatButton(
                    minWidth: 80,
                    child: Text(
                      'Offer',
                      style: Theme.of(context).textTheme.button.apply(
                            color: postType == 'offer'
                                ? Colors.white
                                : Colors.green[300],
                            fontWeightDelta: 2,
                          ),
                    ),
                    color:
                        postType == 'offer' ? Colors.green[300] : Colors.white,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 2,
                          color: Colors.green[300],
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () {
                      setState(() {
                        postType = 'offer';
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.instance.safeBlockHorizontal * 3,
                    ),
                    child: FlatButton(
                      minWidth: 80,
                      child: Text(
                        'Request',
                        style: Theme.of(context).textTheme.button.apply(
                              color: postType == 'request'
                                  ? Colors.white
                                  : Colors.red[300],
                              fontWeightDelta: 2,
                            ),
                      ),
                      color: postType == 'request'
                          ? Colors.red[300]
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 2,
                            color: Colors.red[300],
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: () {
                        setState(() {
                          postType = 'request';
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                textCapitalization: TextCapitalization.sentences,
                autofocus: true,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: 'Your text post',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
