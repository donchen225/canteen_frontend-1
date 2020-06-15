import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class LoadNotifications extends NotificationEvent {
  const LoadNotifications();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'LoadNotifications';
}
