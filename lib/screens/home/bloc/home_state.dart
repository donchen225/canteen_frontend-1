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
  final bool dataLoaded; // only matters if authenticated is true
  final DateTime lastRequested;

  HomeLoaded(
      {this.authenticated = false,
      this.dataLoaded = false,
      this.lastRequested});

  @override
  List<Object> get props => [authenticated, dataLoaded, lastRequested];

  @override
  String toString() =>
      'HomeLoaded { authenticated: $authenticated, dataLoaded: $dataLoaded, lastRequested: $lastRequested }';
}

class OnboardScreenLoaded extends HomeState {
  OnboardScreenLoaded();

  @override
  String toString() => 'OnboardScreenLoaded';
}
