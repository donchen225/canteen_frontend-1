import 'dart:async';
import 'dart:collection';

import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/models/user/user_repository.dart';
import 'package:canteen_frontend/screens/posts/bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/post_screen_bloc/post_screen_event.dart';
import 'package:canteen_frontend/screens/posts/post_screen_bloc/post_screen_state.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostScreenBloc extends Bloc<PostScreenEvent, PostScreenState> {
  final UserRepository _userRepository;
  final PostBloc _postBloc;
  StreamSubscription _postSubscription;
  List<Post> _homePosts = [];
  DoubleLinkedQueue<PostScreenState> _previousStates = DoubleLinkedQueue();

  PostScreenBloc({@required postBloc, @required userRepository})
      : assert(userRepository != null),
        assert(postBloc != null),
        _userRepository = userRepository,
        _postBloc = postBloc {
    _postSubscription = _postBloc.listen((state) {
      if (state is PostsLoaded) {
        _homePosts = state.posts;
      }
    });
  }

  @override
  PostScreenState get initialState =>
      PostScreenLoading(); // TODO: change this to PostScreenUninitialized?

  @override
  Stream<PostScreenState> mapEventToState(
    PostScreenEvent event,
  ) async* {
    if (event is PostsInspectPost) {
      yield* _mapPostsInspectPostToState(event);
    } else if (event is PostsInspectUser) {
      yield* _mapPostsInspectUserToState(event);
    } else if (event is PostsInspectGroup) {
      yield* _mapPostsInspectGroupToState(event);
    } else if (event is PostsHome) {
      yield* _mapPostsHomeToState();
    } else if (event is DiscoverGroups) {
      yield* _mapDiscoverGroupsToState();
    } else if (event is PostsPreviousState) {
      yield* _mapPostsPreviousStateToState();
    }
  }

  Stream<PostScreenState> _mapPostsInspectPostToState(
      PostsInspectPost event) async* {
    _previousStates.add(state);
    yield PostScreenShowPost(
        post: event.post, user: await _userRepository.currentUser());
  }

  Stream<PostScreenState> _mapPostsInspectUserToState(
      PostsInspectUser event) async* {
    _previousStates.add(state);
    yield PostScreenShowProfile(event.user);
  }

  Stream<PostScreenState> _mapPostsInspectGroupToState(
      PostsInspectGroup event) async* {
    _previousStates.add(state);
    yield PostScreenShowGroup(event.group, await _userRepository.currentUser());
  }

  // TODO: paginate results
  Stream<PostScreenState> _mapPostsHomeToState() async* {
    _previousStates.clear();

    final postState = _postBloc.state;

    final posts = postState is PostsLoaded ? postState.posts : _homePosts;
    _homePosts = posts;

    yield PostScreenHome(
        posts: _homePosts, user: await _userRepository.currentUser());
  }

  Stream<PostScreenState> _mapDiscoverGroupsToState() async* {
    _previousStates.add(state);
    yield PostScreenDiscoverGroup();
  }

  Stream<PostScreenState> _mapPostsPreviousStateToState() async* {
    print(_previousStates);
    try {
      final state = _previousStates.removeLast();
      print(state);
      yield state;
    } catch (e) {
      print('Could not return to previous state: $e');
    }
  }

  @override
  Future<void> close() {
    _postSubscription?.cancel();
    return super.close();
  }
}
