import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class HomeNavigationBarState extends Equatable {
  final int numRequests;
  final int numRecommended;

  const HomeNavigationBarState({this.numRequests = 0, this.numRecommended = 0});

  @override
  List<Object> get props => [];
}

class HomeNavigationBarLoaded extends HomeNavigationBarState {
  final int numRequests;
  final int numRecommended;

  const HomeNavigationBarLoaded(
      {this.numRequests = 0, this.numRecommended = 0});

  @override
  List<Object> get props => [numRequests, numRecommended];
}

class HomeNavigationBarLoading extends HomeNavigationBarState {}
