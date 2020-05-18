import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/posts/bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/post_button.dart';
import 'package:canteen_frontend/screens/posts/text_dialog_screen.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostDialogScreen extends StatefulWidget {
  final User user;
  final double height;

  PostDialogScreen({@required this.user, this.height = 500});

  @override
  _PostDialogScreenState createState() => _PostDialogScreenState();
}

class _PostDialogScreenState extends State<PostDialogScreen> {
  TextEditingController _titleController;
  TextEditingController _messageController;

  _PostDialogScreenState();

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController();
    _messageController = TextEditingController();

    _titleController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextDialogScreen(
      title: 'New Post',
      height: widget.height,
      sendWidget: PostButton(
          enabled: _titleController.text.isNotEmpty,
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
          TextField(
            controller: _titleController,
            textCapitalization: TextCapitalization.sentences,
            autofocus: true,
            maxLines: null,
            decoration: InputDecoration(
              hintText: 'Enter your question',
              hintStyle: TextStyle(fontWeight: FontWeight.bold),
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
