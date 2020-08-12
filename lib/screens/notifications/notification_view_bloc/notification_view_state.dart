import 'package:canteen_frontend/models/post/post.dart';
import 'package:equatable/equatable.dart';

abstract class NotificationViewState extends Equatable {
  @override
  List<Object> get props => null;
}

class NotificationViewUninitialized extends NotificationViewState {}

class NotificationViewLoading extends NotificationViewState {}

class NotificationPostLoaded extends NotificationViewState {
  final Post post;
  final String groupId;

  NotificationPostLoaded({this.post, this.groupId});

  @override
  List<Object> get props => [post, groupId];

  @override
  String toString() =>
      'NotificationPostLoaded { post: ${post.id}, groupId: $groupId }';
}
