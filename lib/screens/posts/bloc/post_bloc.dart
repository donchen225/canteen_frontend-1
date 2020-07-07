import 'dart:async';

import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/models/post/post_repository.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/screens/posts/bloc/post_event.dart';
import 'package:canteen_frontend/screens/posts/bloc/post_state.dart';
import 'package:canteen_frontend/shared_blocs/group/bloc.dart';
import 'package:canteen_frontend/shared_blocs/group/group_bloc.dart';
import 'package:canteen_frontend/shared_blocs/group_home/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:canteen_frontend/models/user/user_repository.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository _postRepository;
  final UserRepository _userRepository;
  GroupBloc _groupBloc;
  GroupHomeBloc _groupHomeBloc;
  StreamSubscription _groupSubscription;
  StreamSubscription _groupHomeSubscription;
  Map<String, List<Post>> postList = {};

  PostBloc({
    @required PostRepository postRepository,
    @required UserRepository userRepository,
    GroupBloc groupBloc,
    GroupHomeBloc groupHomeBloc,
  })  : assert(postRepository != null),
        assert(userRepository != null),
        _postRepository = postRepository,
        _userRepository = userRepository,
        _groupBloc = groupBloc,
        _groupHomeBloc = groupHomeBloc {
    if (_groupBloc != null) {
      _groupSubscription = _groupBloc.listen((state) {
        if (state is GroupLoaded) {
          add(LoadPosts(groupId: state.group.id));
        }
      });
    }

    if (_groupHomeBloc != null) {
      _groupHomeSubscription = _groupHomeBloc.listen((state) {
        if (state is GroupHomeLoaded) {
          add(LoadPosts(groupId: state.group.id));
        }
      });
    }
  }

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
    yield PostsLoading();

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
    final updatedPosts = event.updates.item1;

    final userListFuture = Future.wait(updatedPosts.map((update) async {
      return _userRepository.getUser(update.from);
    }));

    final userLikedFuture = Future.wait(updatedPosts.map((update) async {
      return _postRepository.checkLike(event.groupId, update.id);
    }));

    final userList = await userListFuture;
    final userLiked = await userLikedFuture;

    List<DetailedPost> posts = [];
    for (int i = 0; i < updatedPosts.length; i++) {
      User user = userList[i];
      bool liked = userLiked[i];
      Post update = updatedPosts[i];

      posts.add(DetailedPost.fromPost(update, user, liked));
    }

    postList[event.groupId] = posts;

    yield PostsLoaded(groupId: event.groupId, posts: posts);
  }

  Stream<PostState> _mapAddPostToState(AddPost event) async* {
    await _postRepository.addPost(event.groupId, event.post);
    add(LoadPosts(groupId: event.groupId));
  }

  Stream<PostState> _mapAddLikeToState(AddLike event) async* {
    final isMember = _groupHomeBloc.currentUserGroups
        .any((group) => group.id == event.groupId);

    if (isMember) {
      _postRepository.addLike(event.groupId, event.postId, event.like);
    }

    var posts = postList[event.groupId]
        .map((post) => (post as DetailedPost).copy())
        .toList();

    final postIdx = posts.indexWhere((post) => post.id == event.postId);
    posts[postIdx] = posts[postIdx].incrementLikeCount();
    postList[event.groupId] = posts;

    yield PostsLoaded(groupId: event.groupId, posts: posts);
  }

  Stream<PostState> _mapDeleteLikeToState(DeleteLike event) async* {
    final isMember = _groupHomeBloc.currentUserGroups
        .any((group) => group.id == event.groupId);

    if (isMember) {
      _postRepository.deleteLike(event.groupId, event.postId);
    }

    var posts = postList[event.groupId]
        .map((post) => (post as DetailedPost).copy())
        .toList();

    final postIdx = posts.indexWhere((post) => post.id == event.postId);
    posts[postIdx] = posts[postIdx].decrementLikeCount();
    postList[event.groupId] = posts;

    yield PostsLoaded(groupId: event.groupId, posts: posts);
  }

  Stream<PostState> _mapClearPostsToState() async* {
    yield PostsEmpty();
  }

  @override
  Future<void> close() {
    return super.close();
  }

  // void saveDetailedPost(DetailedPost post) {
  //   var idx = 0;
  //   while (idx < _detailedPosts.length) {
  //     if (post.lastUpdated.isAfter(_detailedPosts[idx].lastUpdated)) {
  //       break;
  //     }

  //     idx++;
  //   }
  //   _detailedPosts.insert(idx, post);
  // }

  // void updateDetailedPost(DocumentChangeType type, Post post) {
  //   if (type == DocumentChangeType.modified) {
  //     _detailedPosts.removeWhere((p) => p.id == post.id);
  //     _detailedPosts.insert(0, post);
  //   } else if (type == DocumentChangeType.removed) {
  //     _detailedPosts.removeWhere((p) => p.id == post.id);
  //   }
  // }
}
