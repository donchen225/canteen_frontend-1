import 'dart:async';

import 'package:canteen_frontend/models/notification/notification_repository.dart';
import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/models/post/post_repository.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/notifications/notification_view_bloc/notification_view_event.dart';
import 'package:canteen_frontend/screens/notifications/notification_view_bloc/notification_view_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tuple/tuple.dart';

class NotificationViewBloc
    extends Bloc<NotificationViewEvent, NotificationViewState> {
  final UserRepository _userRepository;
  final NotificationRepository _notificationRepository;
  final PostRepository _postRepository;
  Map<String, Tuple2<DetailedPost, String>> _loadedPosts = {};

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
    } else if (event is ClearNotificationView) {
      yield* _mapClearNotificationViewToState();
    }
  }

  Stream<NotificationViewState> _mapLoadNotificationPostToState(
      LoadNotificationPost event) async* {
    if (event.read && _loadedPosts.containsKey(event.notificationId)) {
      final detailedPost = _loadedPosts[event.notificationId];

      yield NotificationPostLoaded(
          post: detailedPost.item1, groupId: detailedPost.item2);
    } else {
      final post = await _postRepository.getPost(event.postId, event.groupId);
      final user = await _userRepository.getUser(post.from);
      final liked = await _postRepository.checkLike(event.groupId, post.id);

      final detailedPost = DetailedPost.fromPost(post, user, liked);

      _notificationRepository.readNotification(event.notificationId);

      _loadedPosts[event.notificationId] =
          Tuple2<DetailedPost, String>(detailedPost, event.groupId);

      yield NotificationPostLoaded(post: detailedPost, groupId: event.groupId);
    }
  }

  Stream<NotificationViewState> _mapClearNotificationViewToState() async* {
    yield NotificationViewUninitialized();
  }
}
