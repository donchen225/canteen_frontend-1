import 'package:equatable/equatable.dart';

abstract class NotificationViewEvent extends Equatable {
  const NotificationViewEvent();

  @override
  List<Object> get props => [];
}

class LoadNotificationPost extends NotificationViewEvent {
  final String postId;
  final String groupId;
  final String notificationId;
  final bool read;

  const LoadNotificationPost(
      {this.postId, this.groupId, this.notificationId, this.read});

  @override
  List<Object> get props => [postId, groupId, notificationId, read];

  @override
  String toString() =>
      'LoadNotificationPost { postId: $postId, groupId: $groupId, notificationId: $notificationId, read: $read }';
}
