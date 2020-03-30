import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/shared_blocs/user/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateNameForm extends StatefulWidget {
  final UserRepository _userRepository;

  UpdateNameForm({@required userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  _UpdateNameFormState createState() => _UpdateNameFormState();
}

class _UpdateNameFormState extends State<UpdateNameForm> {
  final TextEditingController _displayNameController = TextEditingController();
  UserBloc _userBloc;

  @override
  Widget build(BuildContext context) {
    _userBloc = BlocProvider.of<UserBloc>(context);
    final User user = (_userBloc.state as UserLoaded).user;

    return Form(
      child: TextFormField(
        controller: _displayNameController,
        decoration: InputDecoration(
          labelText: 'Display Name',
        ),
        autocorrect: false,
        onEditingComplete: () {
          _userBloc
              .add(UpdateUserDisplayName(user.id, _displayNameController.text));
        },
      ),
    );
  }
}
