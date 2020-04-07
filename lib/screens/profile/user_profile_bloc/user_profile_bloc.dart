import 'dart:async';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:meta/meta.dart';

import 'package:canteen_frontend/screens/profile/user_profile_bloc/user_profile_event.dart';
import 'package:canteen_frontend/screens/profile/user_profile_bloc/user_profile_state.dart';
import 'package:canteen_frontend/shared_blocs/user/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final UserRepository _userRepository;
  final UserBloc _userBloc;
  StreamSubscription _userSubscription;

  UserProfileBloc({
    @required UserRepository userRepository,
    @required UserBloc userBloc,
  })  : assert(userRepository != null),
        assert(userBloc != null),
        _userRepository = userRepository,
        _userBloc = userBloc {
    _userSubscription = _userBloc.listen((state) {
      print('USER BLOC STATE CHANGE');
      if (state is UserLoaded) {
        add(LoadUserProfile(state.user));
      }
    });
  }

  // TODO: load user profile from local storage first
  @override
  UserProfileState get initialState => UserProfileLoading();

  @override
  Stream<UserProfileState> mapEventToState(
    UserProfileEvent event,
  ) async* {
    if (event is LoadUserProfile) {
      yield* _mapLoadUserProfileToState(event.user);
    } else if (event is EditAboutSection) {
      yield* _mapEditAboutSectionToState(event.user);
    } else if (event is UpdateAboutSection) {
      yield* _mapUpdateAboutSectionToState(event.user, event.about);
    }
  }

  Stream<UserProfileState> _mapLoadUserProfileToState(User user) async* {
    yield UserProfileLoaded(user);
  }

  Stream<UserProfileState> _mapEditAboutSectionToState(User user) async* {
    yield UserProfileEditingAbout(user);
  }

  Stream<UserProfileState> _mapUpdateAboutSectionToState(
      User user, String about) async* {
    final updatedUser = user.updateAbout(about);
    _userRepository.updateAbout(user.id, about);
    yield UserProfileLoaded(updatedUser);
  }
}
