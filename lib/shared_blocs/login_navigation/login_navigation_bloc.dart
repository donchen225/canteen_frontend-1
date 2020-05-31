import 'dart:collection';

import 'package:canteen_frontend/shared_blocs/login_navigation/login_navigation_event.dart';
import 'package:canteen_frontend/shared_blocs/login_navigation/login_navigation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginNavigationBloc
    extends Bloc<LoginNavigationEvent, LoginNavigationState> {
  DoubleLinkedQueue<LoginNavigationState> _previousStates = DoubleLinkedQueue();

  LoginNavigationBloc();

  @override
  LoginNavigationState get initialState => LandingScreenState();

  @override
  Stream<LoginNavigationState> mapEventToState(
    LoginNavigationEvent event,
  ) async* {
    if (event is ViewLoginScreen) {
      yield* _mapViewLoginScreenToState();
    } else if (event is ViewSignupScreen) {
      yield* _mapViewSignupScreenToState();
    } else if (event is LoginPreviousState) {
      yield* _mapLoginPreviousStateToState();
    }
  }

  Stream<LoginNavigationState> _mapViewLoginScreenToState() async* {
    _previousStates.add(state);
    yield LoginScreenState();
  }

  Stream<LoginNavigationState> _mapViewSignupScreenToState() async* {
    _previousStates.add(state);
    yield SignUpScreenState();
  }

  Stream<LoginNavigationState> _mapLoginPreviousStateToState() async* {
    print(_previousStates);
    try {
      final state = _previousStates.removeLast();

      if (state is LoginScreenState) {
        yield LoginScreenState(previous: true);
      } else if (state is SignUpScreenState) {
        yield SignUpScreenState(previous: true);
      } else {
        yield state;
      }
    } catch (e) {
      print('Could not return to previous state: $e');
    }
  }
}
