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

  const UpdateBadgeCount({this.numRequests});

  @override
  List<Object> get props => [numRequests];

  @override
  String toString() => 'UpdateBadgeCount { numRequests: $numRequests }';
}

class ClearBadgeCounts extends HomeNavigationBarEvent {}
