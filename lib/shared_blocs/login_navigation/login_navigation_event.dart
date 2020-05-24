import 'package:equatable/equatable.dart';

abstract class LoginNavigationEvent extends Equatable {
  const LoginNavigationEvent();

  @override
  List<Object> get props => [];
}

class LoginPreviousState extends LoginNavigationEvent {}

class ViewLoginScreen extends LoginNavigationEvent {}

class ViewSignupScreen extends LoginNavigationEvent {}
