import 'dart:async';

import 'package:canteen_frontend/models/notification/notification.dart';
import 'package:canteen_frontend/models/notification/notification_repository.dart';
import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/models/post/post_repository.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/notifications/notification_view_bloc/notification_view_event.dart';
import 'package:canteen_frontend/screens/notifications/notification_view_bloc/notification_view_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class NotificationViewBloc
    extends Bloc<NotificationViewEvent, NotificationViewState> {
  final UserRepository _userRepository;
  final NotificationRepository _notificationRepository;
  final PostRepository _postRepository;
  List<Notification> _notifications = [];
  DocumentSnapshot _lastNotification;

  NotificationViewBloc({
    @required UserRepository userRepository,
    @required NotificationRepository notificationRepository,
    @required PostRepository postRepository,
  })  : assert(userRepository != null),
        assert(notificationRepository != null),
        assert(postRepository != null),
        _userRepository = userRepository,
        _notificationRepository = notificationRepository,
        _postRepository = postRepository;

  @override
  NotificationViewState get initialState => NotificationViewUninitialized();

  @override
  Stream<NotificationViewState> mapEventToState(
      NotificationViewEvent event) async* {
    if (event is LoadNotificationPost) {
      yield* _mapLoadNotificationPostToState(event);
    }
  }

  Stream<NotificationViewState> _mapLoadNotificationPostToState(
      LoadNotificationPost event) async* {
    final post = await _postRepository.getPost(event.postId, event.groupId);
    final user = await _userRepository.getUser(post.from);
    final liked = await _postRepository.checkLike(event.groupId, post.id);

    final detailedPost = DetailedPost.fromPost(post, user, liked);

    if (!event.read) {
      _notificationRepository.readNotification(event.notificationId);
    }

    yield NotificationPostLoaded(post: detailedPost, groupId: event.groupId);
  }
}
