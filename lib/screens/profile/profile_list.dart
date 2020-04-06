import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/profile/profile_picture.dart';
import 'package:flutter/material.dart';

class ProfileList extends StatelessWidget {
  final User user;
  final double height;
  final double width;

  ProfileList(this.user, {@required this.height, @required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: ProfilePicture(
                    photoUrl: user.photoUrl,
                    localPicture:
                        AssetImage('assets/blank-profile-picture.jpeg'),
                    editable: false,
                    size: 160,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                'About',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Card(
              margin: EdgeInsets.all(0),
              elevation: 0.3,
              color: Colors.white,
              child: Container(
                height: 100,
                padding: EdgeInsets.all(10),
                child: Text(user.about ?? ''),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                'I am teaching',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Card(
              margin: EdgeInsets.all(0),
              elevation: 0.3,
              color: Colors.white,
              child: Container(
                height: 100,
                padding: EdgeInsets.all(10),
                child: Text('Skill #1'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                'I am learning',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Card(
              margin: EdgeInsets.all(0),
              elevation: 0.3,
              color: Colors.white,
              child: Container(
                height: 100,
                padding: EdgeInsets.all(10),
                child: Text('Skill #1'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
