import 'package:canteen_frontend/models/notification/notification.dart';
import 'package:equatable/equatable.dart';

abstract class NotificationState extends Equatable {
  @override
  List<Object> get props => null;
}

class NotificationsUninitialized extends NotificationState {}

class NotificationsLoading extends NotificationState {}

class NotificationsLoaded extends NotificationState {
  final List<Notification> notifications;

  NotificationsLoaded({this.notifications});

  @override
  List<Object> get props => [notifications];

  @override
  String toString() => 'NotificationsLoaded { notifications: $notifications }';
}
