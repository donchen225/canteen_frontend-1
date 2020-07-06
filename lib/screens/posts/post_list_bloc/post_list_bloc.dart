import 'dart:async';
import 'package:canteen_frontend/models/post/post_repository.dart';
import 'package:canteen_frontend/screens/posts/bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/bloc/post_bloc.dart';
import 'package:canteen_frontend/screens/posts/post_list_bloc/post_list_event.dart';
import 'package:canteen_frontend/screens/posts/post_list_bloc/post_list_state.dart';
import 'package:canteen_frontend/shared_blocs/group/bloc.dart';
import 'package:canteen_frontend/shared_blocs/group_home/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import 'package:canteen_frontend/models/user/user_repository.dart';

class PostListBloc extends Bloc<PostListEvent, PostListState> {
  final PostBloc _postBloc;
  final GroupBloc _groupBloc;
  final GroupHomeBloc _groupHomeBloc;
  final UserRepository _userRepository;
  final PostRepository _postRepository;
  StreamSubscription _postSubscription;
  StreamSubscription _groupSubscription;
  StreamSubscription _groupHomeSubscription;
  String _currentGroupId;

  PostListBloc(
      {@required PostBloc postBloc,
      GroupBloc groupBloc,
      GroupHomeBloc groupHomeBloc,
      @required UserRepository userRepository,
      @required PostRepository postRepository})
      : assert(postBloc != null),
        assert(userRepository != null),
        assert(postRepository != null),
        _postBloc = postBloc,
        _groupBloc = groupBloc,
        _groupHomeBloc = groupHomeBloc,
        _userRepository = userRepository,
        _postRepository = postRepository {
    _postSubscription = _postBloc.listen((state) {
      if (state is PostsLoaded) {
        final groupId = state.groupId;
        if (_currentGroupId == groupId) {
          add(LoadPostList(groupId: groupId, postList: state.posts));
        }
      }

      // if (state is RequestsUnauthenticated) {
      //   add(ClearPostList());
      // }
    });
    if (_groupBloc != null) {
      _groupSubscription = _groupBloc.listen((state) {
        if (state is GroupLoaded) {
          final groupId = state.group.id;
          final posts = _postBloc.postList[groupId];
          _currentGroupId = groupId;

          if (posts != null) {
            add(LoadPostList(groupId: groupId, postList: posts));
          } else {
            add(LoadingPostList());
          }
        }
      });
    }

    if (_groupHomeBloc != null) {
      _groupHomeSubscription = _groupHomeBloc.listen((state) {
        if (state is GroupHomeLoaded) {
          final groupId = state.group.id;
          final posts = _postBloc.postList[groupId];
          _currentGroupId = groupId;

          if (posts != null) {
            add(LoadPostList(groupId: groupId, postList: posts));
          } else {
            add(LoadingPostList());
          }
        }
      });
    }
  }

  @override
  PostListState get initialState => PostListUninitialized();

  @override
  Stream<PostListState> mapEventToState(PostListEvent event) async* {
    if (event is LoadPostList) {
      yield* _mapLoadPostListToState(event);
    } else if (event is LoadingPostList) {
      yield* _mapLoadingPostListToState();
    } else if (event is ClearPostList) {
      yield* _mapClearPostListToState();
    }
  }

  Stream<PostListState> _mapLoadPostListToState(LoadPostList event) async* {
    yield PostListLoaded(groupId: event.groupId, postList: event.postList);
  }

  Stream<PostListState> _mapLoadingPostListToState() async* {
    yield PostListLoading();
  }

  Stream<PostListState> _mapClearPostListToState() async* {
    yield PostListUninitialized();
  }

  @override
  Future<void> close() {
    _postSubscription?.cancel();
    _groupSubscription?.cancel();
    _groupHomeSubscription?.cancel();
    return super.close();
  }
}
