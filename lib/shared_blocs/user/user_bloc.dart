import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/shared_blocs/user/user_event.dart';
import 'package:canteen_frontend/shared_blocs/user/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  // final AuthenticationBloc _authenticationBloc;
  final UserRepository _userRepository;
  // StreamSubscription _authenticationSubscription;

  UserBloc(
      {@required UserRepository userRepository, @required authenticationBloc})
      : assert(userRepository != null),
        assert(authenticationBloc != null),
        _userRepository = userRepository;
  // _authenticationBloc = authenticationBloc;
  //   {_authenticationSubscription = _authenticationBloc.listen((state) {
  //     if (state is Authenticated) {
  //       print('USER BLOC: STREAM SUBSCRIPTION');
  //       add(LoadUser(state.user));
  //     }
  //   });
  // }

  @override
  UserState get initialState => UserLoading();

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is LoadUser) {
      yield* _mapLoadUserToState(event.firebaseUser);
    } else if (event is UpdateUserDisplayName) {
      yield* _mapUpdateUserDisplayNameToState(event.id, event.displayName);
    } else if (event is LogOutUser) {
      yield* _mapLogOutToState();
    }
  }

  Stream<UserState> _mapLoadUserToState(FirebaseUser user) async* {
    yield UserLoaded(await _userRepository.getUserFromFirebaseUser(user));
  }

  Stream<UserState> _mapUpdateUserDisplayNameToState(
      String id, String name) async* {
    await _userRepository.updateDisplayName(id, name);
    yield UserLoaded(await _userRepository.getUserFromId(id));
  }

  Stream<UserState> _mapLogOutToState() async* {
    yield UserCleared();
  }
}
