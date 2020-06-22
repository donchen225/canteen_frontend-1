import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:canteen_frontend/shared_blocs/settings/bloc.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';

import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository {
    print('IN AUTH BLOC CONSTRUCTOR');
  }

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final user = await _userRepository.getFirebaseUser();
      if (user != null) {
        _userRepository.updateUserSignInTime(user);
        print('APP STARTED WITH USER ID: ${user.uid}');
        await CachedSharedPreferences.setString(
            PreferenceConstants.userId, user.uid);
        yield Authenticated(user);
      } else {
        yield Unauthenticated();
      }
    } catch (e) {
      print('AUTHENTICATION ERROR: $e');
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    final user = await _userRepository.getFirebaseUser();
    _userRepository.updateUserSignInTime(user);
    await CachedSharedPreferences.setString(
        PreferenceConstants.userId, user.uid);
    yield Authenticated(user);
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    // final settingBloc = BlocProvider.of<SettingBloc>(context);
    // StreamSubscription settingsSubscription;
    _userRepository.signOut();
    yield Unauthenticated();
  }
}
