import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class CheckOnboardStatus extends HomeEvent {
  CheckOnboardStatus();

  @override
  String toString() => 'CheckOnboardStatus';
}

class InitializeHome extends HomeEvent {
  InitializeHome();

  @override
  String toString() => 'InitializeHome';
}

class UserHomeLoaded extends HomeEvent {
  @override
  String toString() => 'UserHomeLoaded';
}

class LoadHome extends HomeEvent {
  @override
  String toString() => 'LoadHome';
}

class ClearHome extends HomeEvent {
  @override
  String toString() => 'ClearHome';
}
