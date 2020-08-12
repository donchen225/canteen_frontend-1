import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class HomeNavigationBarBadgeState extends Equatable {
  final int numRequests;
  final int numMessages;
  final int numNotifications;

  const HomeNavigationBarBadgeState(
      {this.numRequests = 0, this.numMessages = 0, this.numNotifications = 0});

  @override
  List<Object> get props => [];
}

class HomeNavigationBarLoaded extends HomeNavigationBarBadgeState {
  final int numRequests;
  final int numMessages;
  final int numNotifications;

  const HomeNavigationBarLoaded(
      {this.numRequests = 0, this.numMessages = 0, this.numNotifications = 0});

  @override
  List<Object> get props => [numRequests, numMessages, numNotifications];
}

class HomeNavigationBarLoading extends HomeNavigationBarBadgeState {}
