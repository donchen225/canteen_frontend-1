import 'package:canteen_frontend/models/notification/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:tuple/tuple.dart';

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

class NotificationsUpdated extends NotificationListEvent {
  final Tuple2<List<Notification>, DocumentSnapshot> updates;

  const NotificationsUpdated(this.updates);

  @override
  List<Object> get props => [updates];

  @override
  String toString() => 'NotificationsUpdated';
}

class LoadOldNotifications extends NotificationListEvent {
  final int page;

  const LoadOldNotifications({this.page});

  @override
  List<Object> get props => [page];

  @override
  String toString() => 'LoadOldNotifications { page: $page }';
}
