import 'package:equatable/equatable.dart';

abstract class LoginNavigationState extends Equatable {
  final bool previous;

  const LoginNavigationState({this.previous = false});

  @override
  List<Object> get props => [];
}

class LandingScreenState extends LoginNavigationState {
  const LandingScreenState();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'LandingScreenState';
}

class LoginScreenState extends LoginNavigationState {
  final bool previous;

  const LoginScreenState({this.previous = false});

  @override
  List<Object> get props => [previous];

  @override
  String toString() => 'LoginScreenState { previous: $previous }';
}

class SignUpScreenState extends LoginNavigationState {
  final bool previous;

  const SignUpScreenState({this.previous = false});

  @override
  List<Object> get props => [previous];

  @override
  String toString() => 'SignUpScreenState { previous: $previous }';
}
