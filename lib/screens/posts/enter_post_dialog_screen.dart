import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

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
                  GestureDetector(
                    onTap: () {
                      // final post = Post();
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                        top: SizeConfig.instance.blockSizeVertical * 2,
                        bottom: SizeConfig.instance.blockSizeVertical * 2,
                        left: SizeConfig.instance.blockSizeHorizontal * 3,
                        right: SizeConfig.instance.blockSizeHorizontal * 3,
                      ),
                      child: Text(
                        'POST',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
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
                        autofocus: true,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'An interesting title',
                          hintStyle: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextField(
                        controller: _messageController,
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
