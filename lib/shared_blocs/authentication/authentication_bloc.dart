import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:canteen_frontend/utils/shared_preferences_util.dart';
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
        CachedSharedPreferences.setString(PreferenceConstants.userId, user.uid);
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
    await _userRepository.updateUserSignInTime(user);
    yield Authenticated(user);
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    _userRepository.signOut();
  }
}
