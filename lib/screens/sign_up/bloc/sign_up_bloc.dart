import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:canteen_frontend/utils/constants.dart';
import 'package:flutter/services.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:canteen_frontend/utils/validators.dart';

import 'bloc.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserRepository _userRepository;

  SignUpBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  SignUpState get initialState => SignUpState.empty();

  @override
  Stream<SignUpState> transformEvents(
    Stream<SignUpEvent> events,
    Stream<SignUpState> Function(SignUpEvent event) next,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! EmailChanged && event is! PasswordChanged);
    });
    final debounceStream = events.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: FORM_REFRESH_MILLISECONDS));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      next,
    );
  }

  @override
  Stream<SignUpState> mapEventToState(
    SignUpEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is Submitted) {
      yield* _mapFormSubmittedToState(event.email, event.password);
    }
  }

  Stream<SignUpState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<SignUpState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<SignUpState> _mapFormSubmittedToState(
    String email,
    String password,
  ) async* {
    yield SignUpState.loading();
    try {
      await _userRepository.signUp(
        email: email,
        password: password,
      );
      yield SignUpState.success();
    } on PlatformException catch (err) {
      yield SignUpState.failureWithError(err);
    }
  }
}
