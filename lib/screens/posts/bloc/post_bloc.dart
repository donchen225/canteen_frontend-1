import 'dart:async';

import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/models/post/post_repository.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/posts/bloc/post_event.dart';
import 'package:canteen_frontend/screens/posts/bloc/post_state.dart';
import 'package:canteen_frontend/shared_blocs/user/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:tuple/tuple.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository _postRepository;
  final UserRepository _userRepository;

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
      final posts = await _postRepository.getPosts(event.groupId);
      add(PostsUpdated(groupId: event.groupId, updates: posts));
    } on PlatformException catch (error) {
      if (error.code == 'Error 7') {
        print('INSUFFICIENT PERMISSIONS');
        yield PostsPrivate();
      }
    }
  }

  Stream<PostState> _mapPostsUpdateToState(PostsUpdated event) async* {
    yield PostsLoading();
    final updatedPosts = event.updates.item1;

    final userListFuture = Future.wait(updatedPosts.map((update) async {
      return _userRepository.getUser(update.from);
    }));

    final userLikedFuture = Future.wait(updatedPosts.map((update) async {
      return _postRepository.checkLike(event.groupId, update.id);
    }));

    final userList = await userListFuture;
    final userLiked = await userLikedFuture;

    for (int i = 0; i < updatedPosts.length; i++) {
      User user = userList[i];
      bool liked = userLiked[i];
      Post update = updatedPosts[i];

      final detailedPost = DetailedPost.fromPost(update, user, liked);
      _postRepository.saveDetailedPost(detailedPost);
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
    yield PostsEmpty();
  }

  @override
  Future<void> close() {
    _postRepository.clearPosts();
    return super.close();
  }
}
