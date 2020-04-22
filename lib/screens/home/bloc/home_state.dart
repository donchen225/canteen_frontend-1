import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeUninitialized extends HomeState {}

class HomeInitializing extends HomeState {}

class CurrentIndexChanged extends HomeState {
  final int currentIndex;

  CurrentIndexChanged({@required this.currentIndex});

  @override
  List<Object> get props => [currentIndex];

  @override
  String toString() => 'CurrentIndexChanged to $currentIndex';
}

class PageLoading extends HomeState {
  @override
  String toString() => 'PageLoading';
}

class RecommendedScreenLoaded extends HomeState {
  final bool reset;

  RecommendedScreenLoaded({this.reset});

  @override
  List<Object> get props => [reset];

  @override
  String toString() => 'RecommendedScreenLoaded { reset: $reset }';
}

class SearchScreenLoaded extends HomeState {
  final bool reset;

  SearchScreenLoaded({this.reset});

  @override
  List<Object> get props => [reset];

  @override
  String toString() => 'SearchScreenLoaded { reset: $reset }';
}

class RequestScreenLoaded extends HomeState {
  final bool reset;

  RequestScreenLoaded({this.reset});

  @override
  List<Object> get props => [reset];

  @override
  String toString() => 'RequestScreenLoaded { reset: $reset }';
}

class MatchScreenLoaded extends HomeState {
  final bool reset;

  MatchScreenLoaded({this.reset});

  @override
  List<Object> get props => [reset];

  @override
  String toString() => 'MatchScreenLoaded { reset: $reset }';
}

class UserProfileScreenLoaded extends HomeState {
  final bool reset;

  UserProfileScreenLoaded({this.reset});

  @override
  List<Object> get props => [reset];

  @override
  String toString() => 'UserProfileScreenLoaded { reset: $reset }';
}

class OnboardScreenLoaded extends HomeState {
  OnboardScreenLoaded();

  @override
  String toString() => 'OnboardScreenLoaded';
}
