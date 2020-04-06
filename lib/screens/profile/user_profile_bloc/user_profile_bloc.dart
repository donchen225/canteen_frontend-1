import 'dart:async';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:meta/meta.dart';

import 'package:canteen_frontend/screens/profile/user_profile_bloc/user_profile_event.dart';
import 'package:canteen_frontend/screens/profile/user_profile_bloc/user_profile_state.dart';
import 'package:canteen_frontend/shared_blocs/user/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final UserBloc _userBloc;
  StreamSubscription _userSubscription;

  UserProfileBloc({@required UserBloc userBloc})
      : assert(userBloc != null),
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
    } else if (event is UpdateAboutSection) {
      yield* _mapUpdateAboutSectionToState(event.user);
    }
  }

  Stream<UserProfileState> _mapLoadUserProfileToState(User user) async* {
    yield UserProfileLoaded(user);
  }

  Stream<UserProfileState> _mapUpdateAboutSectionToState(User user) async* {
    yield UserProfileEditingAbout(user);
  }
}
