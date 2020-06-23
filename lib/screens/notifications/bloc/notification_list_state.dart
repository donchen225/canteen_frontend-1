import 'package:canteen_frontend/models/notification/notification.dart';
import 'package:equatable/equatable.dart';

abstract class NotificationListState extends Equatable {
  @override
  List<Object> get props => null;
}

class NotificationsUninitialized extends NotificationListState {}

class NotificationsLoading extends NotificationListState {}

class NotificationsLoaded extends NotificationListState {
  final List<Notification> notifications;

  NotificationsLoaded({this.notifications});

  @override
  List<Object> get props => [notifications];

  @override
  String toString() => 'NotificationsLoaded';
}
