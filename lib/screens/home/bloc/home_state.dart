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
  HomeLoaded();

  @override
  String toString() => 'HomeLoaded';
}

class OnboardScreenLoaded extends HomeState {
  OnboardScreenLoaded();

  @override
  String toString() => 'OnboardScreenLoaded';
}
