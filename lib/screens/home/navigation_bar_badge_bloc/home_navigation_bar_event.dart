import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class HomeNavigationBarBadgeEvent extends Equatable {
  const HomeNavigationBarBadgeEvent();

  @override
  List<Object> get props => [];
}

class LoadBadgeCounts extends HomeNavigationBarBadgeEvent {}

class UpdateBadgeCount extends HomeNavigationBarBadgeEvent {
  final int numRequests;
  final int numRecommended;

  const UpdateBadgeCount({this.numRequests = 0, this.numRecommended = 0});

  @override
  List<Object> get props => [numRequests, numRecommended];

  @override
  String toString() =>
      'UpdateBadgeCount { numRequests: $numRequests numRecommended: $numRecommended }';
}

class ClearBadgeCounts extends HomeNavigationBarBadgeEvent {}
