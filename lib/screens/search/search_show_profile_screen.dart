import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/search/view_user_profile_screen.dart';
import 'package:flutter/material.dart';

class SearchShowProfileScreen extends StatelessWidget {
  final User user;

  SearchShowProfileScreen({this.user}) : assert(user != null);

  @override
  Widget build(BuildContext context) {
    return ViewUserProfileScreen(user: user);
  }
}
