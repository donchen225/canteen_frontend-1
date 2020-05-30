import 'package:canteen_frontend/models/user/user.dart';

class UserArguments {
  final User user;
  final bool editable;

  UserArguments({this.user, this.editable = false});
}
