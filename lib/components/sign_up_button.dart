import 'package:canteen_frontend/screens/sign_up/bloc/sign_up_bloc.dart';
import 'package:canteen_frontend/screens/sign_up/sign_up_screen.dart';
import 'package:canteen_frontend/shared_blocs/user/bloc.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Palette.primaryColor,
      child: Text(
        'Sign Up',
        style: Theme.of(context).textTheme.button.apply(
              color: Palette.whiteColor,
            ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.instance.safeBlockHorizontal * 10,
      ),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          useRootNavigator: true,
          isScrollControlled: true,
          isDismissible: true,
          enableDrag: true,
          backgroundColor: Colors.transparent,
          builder: (context) => BlocProvider<SignUpBloc>(
            create: (context) => SignUpBloc(
                userRepository:
                    BlocProvider.of<UserBloc>(context).userRepository),
            child: SignUpScreen(),
          ),
        );
      },
    );
  }
}
