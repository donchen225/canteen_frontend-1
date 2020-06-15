import 'package:canteen_frontend/models/comment/comment.dart';
import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/screens/posts/comment_bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/post_button.dart';
import 'package:canteen_frontend/screens/posts/text_dialog_screen.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentDialogScreen extends StatefulWidget {
  final DetailedPost post;
  final double height;
  final String groupId;

  CommentDialogScreen(
      {@required this.post, @required this.groupId, this.height = 500});

  @override
  _CommentDialogScreenState createState() => _CommentDialogScreenState();
}

class _CommentDialogScreenState extends State<CommentDialogScreen> {
  TextEditingController _messageController;

  _CommentDialogScreenState();

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();

    _messageController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId =
        CachedSharedPreferences.getString(PreferenceConstants.userId);
    final userPhotoUrl =
        CachedSharedPreferences.getString(PreferenceConstants.userPhotoUrl);
    final userName =
        CachedSharedPreferences.getString(PreferenceConstants.userName);

    return TextDialogScreen(
      title: 'Add Comment',
      height: widget.height,
      sendWidget: PostButton(
          text: 'Send',
          enabled: _messageController.text.isNotEmpty,
          onTap: (BuildContext context) {
            if (_messageController.text.isNotEmpty) {
              final now = DateTime.now();
              final comment = Comment(
                message: _messageController.text,
                from: currentUserId,
                createdOn: now,
                lastUpdated: now,
              );
              BlocProvider.of<CommentBloc>(context).add(AddComment(
                  groupId: widget.groupId,
                  postId: widget.post.id,
                  comment: comment));
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
                        'Please add a comment',
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
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              ProfilePicture(
                photoUrl: widget.post.user.photoUrl,
                editable: false,
                size: SizeConfig.instance.blockSizeHorizontal * 6,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.instance.blockSizeHorizontal),
                child: Text('${widget.post.user.displayName ?? ''}'),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: SizeConfig.instance.blockSizeVertical * 2,
            ),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: Colors.grey[200],
                ),
              ),
            ),
            child: Text(
              widget.post.message,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: SizeConfig.instance.blockSizeVertical * 2),
            child: Row(
              children: <Widget>[
                ProfilePicture(
                  photoUrl: userPhotoUrl,
                  editable: false,
                  size: SizeConfig.instance.blockSizeHorizontal * 6,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.instance.blockSizeHorizontal),
                  child: Text('${userName ?? ''}'),
                ),
              ],
            ),
          ),
          TextField(
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
              hintText: 'Your comment',
            ),
          ),
        ],
      ),
    );
  }
}
