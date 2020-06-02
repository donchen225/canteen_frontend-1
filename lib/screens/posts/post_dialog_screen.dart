import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/screens/posts/bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/post_button.dart';
import 'package:canteen_frontend/screens/posts/text_dialog_screen.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostDialogScreen extends StatefulWidget {
  final String groupId;
  final double height;

  PostDialogScreen({@required this.groupId, this.height = 500});

  @override
  _PostDialogScreenState createState() => _PostDialogScreenState();
}

class _PostDialogScreenState extends State<PostDialogScreen> {
  TextEditingController _messageController;
  final currentUserId =
      CachedSharedPreferences.getString(PreferenceConstants.userId);
  final userPhotoUrl =
      CachedSharedPreferences.getString(PreferenceConstants.userPhotoUrl);
  final userName =
      CachedSharedPreferences.getString(PreferenceConstants.userName);

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
    return TextDialogScreen(
      title: 'New Post',
      height: widget.height,
      sendWidget: PostButton(
          enabled: _messageController.text.isNotEmpty,
          onTap: (BuildContext context) {
            if (_messageController.text.isNotEmpty) {
              final now = DateTime.now();
              final post = Post(
                message: _messageController.text,
                from: currentUserId,
                createdOn: now,
                lastUpdated: now,
              );
              BlocProvider.of<PostBloc>(context)
                  .add(AddPost(groupId: widget.groupId, post: post));
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
