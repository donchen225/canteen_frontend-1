import 'dart:async';

import 'package:canteen_frontend/shared_blocs/profile_bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;

  ProfileBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  ProfileState get initialState => ProfileUninitialized();

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is LoadProfile) {
      yield* _mapLoadProfileToState(event);
    }
  }

  Stream<ProfileState> _mapLoadProfileToState(LoadProfile event) async* {
    yield ProfileLoading();

    final user = await _userRepository.getUser(event.userId);

    yield ProfileLoaded(user);
  }
}
