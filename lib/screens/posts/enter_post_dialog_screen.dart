import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/posts/bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/post_button.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnterPostDialogScreen extends StatefulWidget {
  final User user;

  EnterPostDialogScreen({@required this.user});

  @override
  _EnterPostDialogScreenState createState() => _EnterPostDialogScreenState();
}

class _EnterPostDialogScreenState extends State<EnterPostDialogScreen> {
  TextEditingController _titleController;
  TextEditingController _messageController;

  _EnterPostDialogScreenState();

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController();
    _messageController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.instance.blockSizeVertical * 90,
      decoration: BoxDecoration(
        color: const Color(0xFFFEFFFF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: const Color(0xFFFEFFFF),
          leading: CloseButton(),
          title: Text('New Post'),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.instance.blockSizeHorizontal * 3,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  PostButton(onTap: (BuildContext context) {
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
                                      SizeConfig.instance.blockSizeHorizontal *
                                          3),
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
                ],
              ),
            ),
          ],
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(15),
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    top: SizeConfig.instance.blockSizeVertical * 3,
                    left: SizeConfig.instance.blockSizeHorizontal * 6,
                    right: SizeConfig.instance.blockSizeHorizontal * 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        width: 1,
                        color: const Color(0xFFDEE0D1),
                      ),
                    ),
                  ),
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
                                horizontal:
                                    SizeConfig.instance.blockSizeHorizontal),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
