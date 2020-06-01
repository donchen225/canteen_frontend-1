import 'dart:async';

import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/models/post/post_repository.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/posts/bloc/post_event.dart';
import 'package:canteen_frontend/screens/posts/bloc/post_state.dart';
import 'package:canteen_frontend/shared_blocs/user/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:tuple/tuple.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository _postRepository;
  final UserRepository _userRepository;
  StreamSubscription _postSubscription;

  PostBloc({
    @required PostRepository postRepository,
    @required UserRepository userRepository,
  })  : assert(postRepository != null),
        assert(userRepository != null),
        _postRepository = postRepository,
        _userRepository = userRepository;

  @override
  PostState get initialState => PostsEmpty();

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    if (event is LoadPosts) {
      yield* _mapLoadPostsToState(event);
    } else if (event is PostsUpdated) {
      yield* _mapPostsUpdateToState(event);
    } else if (event is AddPost) {
      yield* _mapAddPostToState(event);
    } else if (event is AddLike) {
      yield* _mapAddLikeToState(event);
    } else if (event is DeleteLike) {
      yield* _mapDeleteLikeToState(event);
    } else if (event is ClearPosts) {
      yield* _mapClearPostsToState();
    }
  }

  Stream<PostState> _mapLoadPostsToState(LoadPosts event) async* {
    try {
      _postSubscription?.cancel();
      _postSubscription =
          _postRepository.getPosts(event.groupId).listen((posts) {
        print('LOADING POSTS: $posts');
        add(PostsUpdated(groupId: event.groupId, updates: posts));
      });
    } catch (exception) {
      print(exception.errorMessage());
    }
  }

  Stream<PostState> _mapPostsUpdateToState(PostsUpdated event) async* {
    yield PostsLoading();
    final updatedPosts = event.updates;

    final userListFuture = Future.wait(updatedPosts.map((update) async {
      if (update.item1 == DocumentChangeType.modified ||
          update.item1 == DocumentChangeType.added) {
        return _userRepository.getUser(update.item2.from);
      }
      return Future<User>.value(null);
    }));

    final userLikedFuture = Future.wait(updatedPosts.map((update) async {
      if (update.item1 == DocumentChangeType.modified ||
          update.item1 == DocumentChangeType.added) {
        return _postRepository.checkLike(event.groupId, update.item2.id);
      }
      return Future<bool>.value(false);
    }));

    final userList = await userListFuture;
    final userLiked = await userLikedFuture;

    for (int i = 0; i < updatedPosts.length; i++) {
      User user = userList[i];
      bool liked = userLiked[i];
      Tuple2<DocumentChangeType, Post> update = updatedPosts[i];

      if (update.item1 == DocumentChangeType.added ||
          update.item1 == DocumentChangeType.modified) {
        final detailedPost = DetailedPost.fromPost(update.item2, user, liked);

        if (update.item1 == DocumentChangeType.added) {
          _postRepository.saveDetailedPost(detailedPost);
        } else {
          _postRepository.updateDetailedPost(update.item1, detailedPost);
        }
      } else if (update.item1 == DocumentChangeType.removed) {
        _postRepository.updateDetailedPost(update.item1, update.item2);
      }
    }

    yield PostsLoaded(
        groupId: event.groupId, posts: _postRepository.currentDetailedPosts());
  }

  Stream<PostState> _mapAddPostToState(AddPost event) async* {
    _postRepository.addPost(event.groupId, event.post);
  }

  Stream<PostState> _mapAddLikeToState(AddLike event) async* {
    _postRepository.addLike(event.groupId, event.postId, event.like);
  }

  Stream<PostState> _mapDeleteLikeToState(DeleteLike event) async* {
    _postRepository.deleteLike(event.groupId, event.postId);
  }

  Stream<PostState> _mapClearPostsToState() async* {
    _postRepository.clearPosts();
    _postSubscription?.cancel();
    yield PostsEmpty();
  }

  @override
  Future<void> close() {
    _postRepository.clearPosts();
    _postSubscription?.cancel();
    return super.close();
  }
}
