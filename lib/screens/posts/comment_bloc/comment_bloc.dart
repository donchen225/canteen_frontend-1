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
  Map<String, List<Comment>> commentList = {};
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
    } else if (event is AddComment) {
      yield* _mapAddCommentToState(event);
    } else if (event is ClearComments) {
      yield* _mapClearCommentsToState();
    }
  }

  Stream<CommentState> _mapLoadCommentsToState(LoadComments event) async* {
    try {
      yield CommentsLoading();

      StreamSubscription commentsSubscription =
          commentsSubscriptionMap[event.postId];
      commentsSubscription?.cancel();
      commentsSubscription = _postRepository
          .getComments(event.groupId, event.postId)
          .listen((comments) => add(CommentsUpdated(event.postId, comments)));

      commentsSubscriptionMap[event.postId] = commentsSubscription;
    } catch (exception) {
      print(exception);
    }
  }

  Stream<CommentState> _mapCommentsUpdateToState(CommentsUpdated event) async* {
    yield CommentsLoading();
    final updatedComments = event.updates;

    final userListFuture = Future.wait(updatedComments.map((update) async {
      if (update.item1 == DocumentChangeType.modified ||
          update.item1 == DocumentChangeType.added) {
        return _userRepository.getUser(update.item2.from);
      }
      return Future<User>.value(null);
    }));

    final userList = await userListFuture;

    for (int i = 0; i < updatedComments.length; i++) {
      User user = userList[i];
      Tuple2<DocumentChangeType, Comment> update = updatedComments[i];

      if (update.item1 == DocumentChangeType.added ||
          update.item1 == DocumentChangeType.modified) {
        final detailedComment = DetailedComment.fromComment(update.item2, user);

        if (update.item1 == DocumentChangeType.added) {
          _postRepository.saveDetailedComment(event.postId, detailedComment);
        } else {
          _postRepository.updateDetailedComment(
              event.postId, update.item1, detailedComment);
        }
      } else if (update.item1 == DocumentChangeType.removed) {
        _postRepository.updateDetailedComment(
            event.postId, update.item1, update.item2);
      }
    }

    yield CommentsLoaded(
        comments: _postRepository.currentDetailedComments(event.postId));
  }

  Stream<CommentState> _mapAddCommentToState(AddComment event) async* {
    _postRepository.addComment(event.groupId, event.postId, event.comment);
  }

  Stream<CommentState> _mapClearCommentsToState() async* {
    _postRepository.clearComments();
    yield CommentsEmpty();
  }

  @override
  Future<void> close() {
    _postRepository.clearComments();
    commentsSubscriptionMap.forEach((_, subscription) => subscription.cancel());
    return super.close();
  }
}
