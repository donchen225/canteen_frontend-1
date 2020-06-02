import 'dart:async';

import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/posts/bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/post_list_bloc/post_list_event.dart';
import 'package:canteen_frontend/screens/posts/post_list_bloc/post_list_state.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostListBloc extends Bloc<PostListEvent, PostListState> {
  final UserRepository _userRepository;
  final PostBloc _postBloc;
  StreamSubscription _postSubscription;
  Map<String, List<Post>> _postList = {};

  PostListBloc({@required postBloc, @required userRepository})
      : assert(userRepository != null),
        assert(postBloc != null),
        _userRepository = userRepository,
        _postBloc = postBloc {
    _postSubscription = _postBloc.listen((state) {
      if (state is PostsLoaded) {
        add(LoadPostList(groupId: state.groupId, posts: state.posts));
        _postList[state.groupId] = state.posts;
      } else if (state is PostsPrivate) {
        add(DenyPostList());
      }
    });
  }

  @override
  PostListState get initialState => PostListLoading();

  @override
  Stream<PostListState> mapEventToState(
    PostListEvent event,
  ) async* {
    if (event is LoadPostList) {
      yield* _mapLoadPostListToState(event);
    } else if (event is DenyPostList) {
      yield* _mapDenyPostListToState();
    }
  }

  Stream<PostListState> _mapLoadPostListToState(LoadPostList event) async* {
    // TODO: add force reload of posts
    yield PostListLoaded(
        posts: event.posts,
        user: await _userRepository.currentUser(),
        groupId: event.groupId);
  }

  Stream<PostListState> _mapDenyPostListToState() async* {
    yield PostListPrivate();
  }

  @override
  Future<void> close() {
    _postSubscription?.cancel();
    return super.close();
  }
}
