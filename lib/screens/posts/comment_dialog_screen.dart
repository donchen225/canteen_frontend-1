import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/posts/bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/post_button.dart';
import 'package:canteen_frontend/screens/posts/text_dialog_screen.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentDialogScreen extends StatefulWidget {
  final User user;
  final DetailedPost post;

  CommentDialogScreen({@required this.user, @required this.post});

  @override
  _CommentDialogScreenState createState() => _CommentDialogScreenState();
}

class _CommentDialogScreenState extends State<CommentDialogScreen> {
  TextEditingController _titleController;
  TextEditingController _messageController;

  _CommentDialogScreenState();

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController();
    _messageController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return TextDialogScreen(
      title: 'Add Comment',
      sendWidget: PostButton(
          text: 'SEND',
          onTap: (BuildContext context) {
            if (_titleController.text.isNotEmpty) {
              final now = DateTime.now();
              final post = Post(
                title: _titleController.text,
                message: _messageController.text,
                from: widget.user.id,
                createdOn: now,
                lastUpdated: now,
              );
              BlocProvider.of<PostBloc>(context).add(AddPost(post));
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
                        'Please enter a question',
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
              widget.post.title,
              style: TextStyle(
                fontSize: SizeConfig.instance.blockSizeVertical * 2.4 * 1.2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: SizeConfig.instance.blockSizeVertical * 2),
            child: Row(
              children: <Widget>[
                ProfilePicture(
                  photoUrl: widget.user.photoUrl,
                  editable: false,
                  size: SizeConfig.instance.blockSizeHorizontal * 6,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.instance.blockSizeHorizontal),
                  child: Text('${widget.user.displayName ?? ''}'),
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
              hintText: 'Your text post (optional)',
            ),
          ),
        ],
      ),
    );
  }
}
