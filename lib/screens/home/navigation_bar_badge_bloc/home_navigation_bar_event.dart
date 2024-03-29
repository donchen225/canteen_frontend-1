import 'package:canteen_frontend/models/match/match.dart';
import 'package:canteen_frontend/models/notification/notification.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class HomeNavigationBarBadgeEvent extends Equatable {
  const HomeNavigationBarBadgeEvent();

  @override
  List<Object> get props => [];
}

class LoadBadgeCounts extends HomeNavigationBarBadgeEvent {}

class UpdateRequestCount extends HomeNavigationBarBadgeEvent {
  final int numRequests;

  const UpdateRequestCount({this.numRequests});

  @override
  List<Object> get props => [numRequests];

  @override
  String toString() => 'UpdateRequestCount { numRequests: $numRequests }';
}

class UpdateMessageCount extends HomeNavigationBarBadgeEvent {
  final List<Match> matches;

  const UpdateMessageCount({this.matches});

  @override
  List<Object> get props => [matches];

  @override
  String toString() => 'UpdateRequestCount { matches: $matches }';
}

class UpdateNotificationCount extends HomeNavigationBarBadgeEvent {
  final List<Notification> notifications;

  const UpdateNotificationCount({this.notifications});

  @override
  List<Object> get props => [notifications];

  @override
  String toString() => 'UpdateNotificationCount';
}

class ReadNotificationCount extends HomeNavigationBarBadgeEvent {}

class ClearBadgeCounts extends HomeNavigationBarBadgeEvent {}
