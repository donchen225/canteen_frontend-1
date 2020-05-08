import 'dart:async';

import 'package:canteen_frontend/models/comment/comment.dart';
import 'package:canteen_frontend/models/post/post.dart';
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
  UserBloc _userBloc;
  User _self;
  StreamSubscription _userSubscription;
  Map<String, StreamSubscription> commentsSubscriptionMap = Map();

  CommentBloc(
      {@required PostRepository postRepository,
      @required UserRepository userRepository,
      @required UserBloc userBloc})
      : assert(postRepository != null),
        assert(userRepository != null),
        assert(userBloc != null),
        _postRepository = postRepository,
        _userRepository = userRepository,
        _userBloc = userBloc {
    _userSubscription = _userBloc.listen((state) {
      print('POST BLOC USER SUBSCRIPTION RECEIVED EVENT');
      if (state is UserLoaded) {
        _self = state.user;
      }
    });
  }

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
          .getComments(event.postId)
          .listen((comments) => add(CommentsUpdated(event.postId, comments)));

      commentsSubscriptionMap[event.postId] = commentsSubscription;

      if (_self == null) {
        print('USER IS NULL!!!!');
        _self = await _userRepository.currentUser();
        print('USER IS STILL NULL!!!!');
      }
    } catch (exception) {
      print(exception.errorMessage());
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
    _postRepository.addComment(event.postId, event.comment);
  }

  Stream<CommentState> _mapClearCommentsToState() async* {
    _self = null;
    _postRepository.clearComments();
    yield CommentsEmpty();
  }

  @override
  Future<void> close() {
    _postRepository.clearComments();
    commentsSubscriptionMap.forEach((_, subscription) => subscription.cancel());
    _userSubscription?.cancel();
    return super.close();
  }
}
