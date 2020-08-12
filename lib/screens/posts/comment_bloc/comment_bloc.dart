import 'dart:async';

import 'package:canteen_frontend/models/comment/comment.dart';
import 'package:canteen_frontend/models/post/post_repository.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/posts/comment_bloc/comment_event.dart';
import 'package:canteen_frontend/screens/posts/comment_bloc/comment_state.dart';
import 'package:canteen_frontend/shared_blocs/user/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:tuple/tuple.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final PostRepository _postRepository;
  final UserRepository _userRepository;
  Map<String, List<DetailedComment>> commentList = {};
  Map<String, StreamSubscription> commentsSubscriptionMap = Map();

  CommentBloc(
      {@required PostRepository postRepository,
      @required UserRepository userRepository,
      @required UserBloc userBloc})
      : assert(postRepository != null),
        assert(userRepository != null),
        assert(userBloc != null),
        _postRepository = postRepository,
        _userRepository = userRepository;

  @override
  CommentState get initialState => CommentsEmpty();

  @override
  Stream<CommentState> mapEventToState(CommentEvent event) async* {
    if (event is LoadComments) {
      yield* _mapLoadCommentsToState(event);
    } else if (event is CommentsUpdated) {
      yield* _mapCommentsUpdateToState(event);
    } else if (event is ClearComments) {
      yield* _mapClearCommentsToState();
    }
  }

  Stream<CommentState> _mapLoadCommentsToState(LoadComments event) async* {
    try {
      final existingComments = commentList[event.postId];

      StreamSubscription commentsSubscription =
          commentsSubscriptionMap[event.postId];
      commentsSubscription?.cancel();

      final lastFetch = existingComments != null && existingComments.isNotEmpty
          ? existingComments.first.lastUpdated
          : null;

      commentsSubscription = _postRepository
          .getComments(event.groupId, event.postId, lastFetch: lastFetch)
          .listen((comments) => add(CommentsUpdated(event.postId, comments)));

      commentsSubscriptionMap[event.postId] = commentsSubscription;
    } catch (exception) {
      print('Error loading comments: $exception');
    }
  }

  Stream<CommentState> _mapCommentsUpdateToState(CommentsUpdated event) async* {
    final updatedComments = event.updates;

    final userListFuture = Future.wait(updatedComments.map((update) async {
      if (update.item1 == DocumentChangeType.modified ||
          update.item1 == DocumentChangeType.added) {
        return _userRepository.getUser(update.item2.from);
      }
      return Future<User>.value(null);
    }));

    final userList = await userListFuture;

    List<DetailedComment> comments = [];
    comments.addAll(commentList[event.postId] ?? []);

    for (int i = 0; i < updatedComments.length; i++) {
      User user = userList[i];
      Tuple2<DocumentChangeType, Comment> update = updatedComments[i];

      if (update.item1 == DocumentChangeType.added ||
          update.item1 == DocumentChangeType.modified) {
        final detailedComment = DetailedComment.fromComment(update.item2, user);

        if (update.item1 == DocumentChangeType.added) {
          _saveDetailedComment(comments, event.postId, detailedComment);
        } else {
          _updateDetailedComment(
              comments, event.postId, update.item1, detailedComment);
        }
      } else if (update.item1 == DocumentChangeType.removed) {
        _updateDetailedComment(
            comments, event.postId, update.item1, update.item2);
      }
    }

    commentList[event.postId] = comments;

    yield CommentsLoaded(comments: comments, postId: event.postId);
  }

  Stream<CommentState> _mapClearCommentsToState() async* {
    commentList = {};
    yield CommentsEmpty();
  }

  @override
  Future<void> close() {
    commentList = {};
    commentsSubscriptionMap.forEach((_, subscription) => subscription.cancel());
    return super.close();
  }

  // TODO: add extension methods for List<DetailedComment>
  void _saveDetailedComment(List<DetailedComment> commentList, String postId,
      DetailedComment comment) {
    var idx = 0;

    while (idx < commentList.length) {
      if (comment.lastUpdated.isAfter(commentList[idx].lastUpdated)) {
        break;
      }

      idx++;
    }
    commentList.insert(idx, comment);
  }

  void _updateDetailedComment(List<DetailedComment> commentList, String postId,
      DocumentChangeType type, Comment comment) {
    if (type == DocumentChangeType.modified) {
      commentList.removeWhere((c) => c.id == comment.id);
      commentList.insert(0, comment);
    } else if (type == DocumentChangeType.removed) {
      commentList.removeWhere((c) => c.id == comment.id);
    }
  }
}
