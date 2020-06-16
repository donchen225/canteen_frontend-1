import 'package:equatable/equatable.dart';

abstract class NotificationViewEvent extends Equatable {
  const NotificationViewEvent();

  @override
  List<Object> get props => [];
}

class LoadNotificationPost extends NotificationViewEvent {
  final String postId;
  final String groupId;

  const LoadNotificationPost({this.postId, this.groupId});

  @override
  List<Object> get props => [postId, groupId];

  @override
  String toString() =>
      'LoadNotificationPost { postId: $postId, groupId: $groupId }';
}
