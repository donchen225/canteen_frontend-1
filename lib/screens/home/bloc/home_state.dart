import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeUninitialized extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final bool authenticated;

  HomeLoaded({this.authenticated = false});

  @override
  List<Object> get props => [authenticated];

  @override
  String toString() => 'HomeLoaded { authenticated: $authenticated }';
}

class OnboardScreenLoaded extends HomeState {
  OnboardScreenLoaded();

  @override
  String toString() => 'OnboardScreenLoaded';
}
