import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeUninitialized extends HomeState {}

class CurrentIndexChanged extends HomeState {
  final int currentIndex;

  CurrentIndexChanged({@required this.currentIndex});

  @override
  String toString() => 'CurrentIndexChanged to $currentIndex';
}

class PageLoading extends HomeState {
  @override
  String toString() => 'PageLoading';
}

class RecommendedScreenLoaded extends HomeState {
  RecommendedScreenLoaded();

  @override
  String toString() => 'RecommendedScreenLoaded';
}

class SearchScreenLoaded extends HomeState {
  SearchScreenLoaded();

  @override
  String toString() => 'SearchScreenLoaded';
}

class RequestScreenLoaded extends HomeState {
  RequestScreenLoaded();

  @override
  String toString() => 'RequestScreenLoaded';
}

class MatchScreenLoaded extends HomeState {
  MatchScreenLoaded();

  @override
  String toString() => 'MatchScreenLoaded';
}

class UserProfileScreenLoaded extends HomeState {
  UserProfileScreenLoaded();

  @override
  String toString() => 'UserProfileScreenLoaded';
}

class OnboardScreenLoaded extends HomeState {
  OnboardScreenLoaded();

  @override
  String toString() => 'OnboardScreenLoaded';
}
