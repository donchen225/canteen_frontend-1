import 'package:equatable/equatable.dart';

abstract class NotificationListEvent extends Equatable {
  const NotificationListEvent();

  @override
  List<Object> get props => [];
}

class LoadNotifications extends NotificationListEvent {
  const LoadNotifications();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'LoadNotifications';
}
