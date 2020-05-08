import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/screens/posts/post_name_template.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class SinglePostScreen extends StatelessWidget {
  final DetailedPost post;
  final Color _sideTextColor = Colors.grey[500];

  SinglePostScreen({@required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 1,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(
                top: SizeConfig.instance.blockSizeVertical,
                left: SizeConfig.instance.blockSizeHorizontal * 4,
                right: SizeConfig.instance.blockSizeHorizontal * 4,
              ),
              children: <Widget>[
                PostNameTemplate(
                  name: post.user.displayName,
                  photoUrl: post.user.photoUrl,
                  time: post.createdOn,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.instance.blockSizeVertical * 2,
                  ),
                  child: Text(
                    post.title,
                    style: TextStyle(
                      fontSize:
                          SizeConfig.instance.blockSizeVertical * 2.4 * 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(post.message),
              ],
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: SizeConfig.instance.blockSizeVertical,
                    bottom: SizeConfig.instance.blockSizeVertical,
                  ),
                  child: Container(
                    padding: EdgeInsets.only(
                      top: SizeConfig.instance.blockSizeVertical * 2,
                      bottom: SizeConfig.instance.blockSizeVertical * 2,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1,
                          color: Colors.grey[100],
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                            child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  right:
                                      SizeConfig.instance.blockSizeHorizontal *
                                          2),
                              child: Container(
                                height:
                                    SizeConfig.instance.blockSizeVertical * 2.2,
                                width:
                                    SizeConfig.instance.blockSizeVertical * 2.2,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/up-arrow.png'),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              '0',
                              style: TextStyle(
                                  color: _sideTextColor,
                                  fontSize:
                                      SizeConfig.instance.blockSizeVertical *
                                          1.8,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    right: SizeConfig
                                            .instance.blockSizeHorizontal *
                                        2),
                                child: Icon(
                                  Icons.mode_comment,
                                  size: SizeConfig.instance.blockSizeVertical *
                                      2.2,
                                  color: _sideTextColor,
                                ),
                              ),
                              Text(
                                'Comment',
                                style: TextStyle(
                                    color: _sideTextColor,
                                    fontSize:
                                        SizeConfig.instance.blockSizeVertical *
                                            1.8,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Container(),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: SizeConfig.instance.blockSizeHorizontal * 3,
                    right: SizeConfig.instance.blockSizeHorizontal * 3,
                    bottom: SizeConfig.instance.safeBlockVertical * 3,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.instance.blockSizeHorizontal * 3,
                    ),
                    height: SizeConfig.instance.safeBlockVertical * 6,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                    ),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Add a comment',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
