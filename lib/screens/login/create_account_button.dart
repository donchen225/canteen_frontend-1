import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:canteen_frontend/screens/sign_up/sign_up_screen.dart';

class CreateAccountButton extends StatelessWidget {
  final UserRepository _userRepository;

  CreateAccountButton({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        'Create an Account',
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return SignUpScreen(userRepository: _userRepository);
          }),
        );
      },
    );
  }
}
