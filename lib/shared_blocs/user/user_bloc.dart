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
  final UserRepository userRepository;
  StreamSubscription _userSubscription;
  StreamSubscription _authSubscription;
  User currentUser;

  UserBloc(
      {@required this.userRepository,
      @required AuthenticationBloc authenticationBloc})
      : assert(userRepository != null),
        assert(authenticationBloc != null),
        _authenticationBloc = authenticationBloc {
    _authSubscription = _authenticationBloc.listen((authState) {
      if (!(authState is Authenticated) && !(state is UserEmpty)) {
        currentUser = null;
        add(LogOutUser());
      }
    });
  }

  @override
  UserState get initialState => UserEmpty();

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is InitializeUser) {
      yield* _mapInitializeUserToState(event.firebaseUser);
    } else if (event is LoadUser) {
      yield* _mapLoadUserToState(event.user);
    } else if (event is LogOutUser) {
      yield* _mapLogOutToState();
    }
  }

  Stream<UserState> _mapInitializeUserToState(
      FirebaseUser firebaseUser) async* {
    _userSubscription?.cancel();
    _userSubscription =
        userRepository.getCurrentUser(firebaseUser.uid).listen((user) {
      add(LoadUser(user));
    });
  }

  Stream<UserState> _mapLoadUserToState(User user) async* {
    currentUser = user;
    yield UserLoaded(user);
  }

  Stream<UserState> _mapLogOutToState() async* {
    currentUser = null;
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
