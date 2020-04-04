import 'dart:async';

import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/shared_blocs/authentication/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/shared_blocs/user/user_event.dart';
import 'package:canteen_frontend/shared_blocs/user/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final AuthenticationBloc _authenticationBloc;
  final UserRepository _userRepository;
  StreamSubscription _userSubscription;
  StreamSubscription _authSubscription;

  UserBloc(
      {@required UserRepository userRepository,
      @required AuthenticationBloc authenticationBloc})
      : assert(userRepository != null),
        assert(authenticationBloc != null),
        _userRepository = userRepository,
        _authenticationBloc = authenticationBloc {
    print('IN USER BLOC CONSTRUCTOR');
    _authSubscription = _authenticationBloc.listen((state) {
      print('AUTH BLOC CHANGED');
      if (!(state is Authenticated)) {
        print('AUTH BLOC IS NOT AUTHENTICATED, CANCELLING USER SUBSCRIPTION');
        add(LogOutUser());
      }
    });
  }

  @override
  UserState get initialState => UserLoading();

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is InitializeUser) {
      yield* _mapInitializeUserToState(event.firebaseUser);
    } else if (event is LoadUser) {
      yield* _mapLoadUserToState(event.user);
    } else if (event is UpdateUserDisplayName) {
      yield* _mapUpdateUserDisplayNameToState(event.id, event.displayName);
    } else if (event is LogOutUser) {
      yield* _mapLogOutToState();
    }
  }

  Stream<UserState> _mapInitializeUserToState(
      FirebaseUser firebaseUser) async* {
    print('INITIALIZING USER');
    _userSubscription?.cancel();
    _userSubscription =
        _userRepository.getCurrentUser(firebaseUser.uid).listen((user) {
      print('DETECTED USER CHANGE');
      add(LoadUser(user));
    });
  }

  // TODO: add logic to check local user data once implemented and
  // update data if new
  Stream<UserState> _mapLoadUserToState(User user) async* {
    yield UserLoaded(user);
  }

  Stream<UserState> _mapUpdateUserDisplayNameToState(
      String id, String name) async* {
    await _userRepository.updateDisplayName(id, name);
    yield UserLoaded(await _userRepository.getUser(id));
  }

  Stream<UserState> _mapLogOutToState() async* {
    _userSubscription?.cancel();
    yield UserEmpty();
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    _authSubscription?.cancel();
    return super.close();
  }
}
