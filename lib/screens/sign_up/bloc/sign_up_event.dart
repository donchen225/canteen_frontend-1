import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends SignUpEvent {
  final String email;

  const EmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged { email :$email }';
}

class PasswordChanged extends SignUpEvent {
  final String password;

  const PasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class Submitted extends SignUpEvent {
  final String email;
  final String password;
  final String name;

  const Submitted({
    @required this.email,
    @required this.password,
    @required this.name,
  });

  @override
  List<Object> get props => [email, password, name];

  @override
  String toString() {
    return 'Submitted { email: $email, password: $password, name: $name }';
  }
}
