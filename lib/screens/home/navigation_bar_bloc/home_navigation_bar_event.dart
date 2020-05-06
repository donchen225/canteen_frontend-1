import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class HomeNavigationBarEvent extends Equatable {
  const HomeNavigationBarEvent();

  @override
  List<Object> get props => [];
}

class LoadBadgeCounts extends HomeNavigationBarEvent {}

class UpdateBadgeCount extends HomeNavigationBarEvent {
  final int numRequests;
  final int numRecommended;

  const UpdateBadgeCount({this.numRequests = 0, this.numRecommended = 0});

  @override
  List<Object> get props => [numRequests, numRecommended];

  @override
  String toString() =>
      'UpdateBadgeCount { numRequests: $numRequests numRecommended: $numRecommended }';
}

class ClearBadgeCounts extends HomeNavigationBarEvent {}
