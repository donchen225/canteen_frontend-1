import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class HomeNavigationBarState extends Equatable {
  final int numRequests;

  const HomeNavigationBarState({this.numRequests = 0});

  @override
  List<Object> get props => [];
}

class HomeNavigationBarLoaded extends HomeNavigationBarState {
  final int numRequests;

  const HomeNavigationBarLoaded({this.numRequests = 0});

  @override
  List<Object> get props => [numRequests];
}

class HomeNavigationBarLoading extends HomeNavigationBarState {}
