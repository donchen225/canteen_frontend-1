import 'dart:async';
import 'package:canteen_frontend/models/post/post_repository.dart';
import 'package:canteen_frontend/screens/posts/bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/bloc/post_bloc.dart';
import 'package:canteen_frontend/screens/posts/single_post_bloc/single_post_event.dart';
import 'package:canteen_frontend/screens/posts/single_post_bloc/single_post_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class SinglePostBloc extends Bloc<SinglePostEvent, SinglePostState> {
  final PostBloc _postBloc;
  final PostRepository _postRepository;
  StreamSubscription _postSubscription;
  String _currentPostId;
  String _currentPostGroupId;

  SinglePostBloc(
      {@required PostBloc postBloc, @required PostRepository postRepository})
      : assert(postBloc != null),
        assert(postRepository != null),
        _postBloc = postBloc,
        _postRepository = postRepository {
    _postSubscription = _postBloc.listen((state) {
      if (state is PostsLoaded) {
        if (_currentPostId != null && _currentPostId.isNotEmpty) {
          final updatedPost = state.posts.firstWhere(
              (post) => post.id == _currentPostId,
              orElse: () => null);

          if (updatedPost != null) {
            add(LoadSinglePost(
                post: updatedPost, groupId: _currentPostGroupId));
          }
        }
      }
    });
  }

  @override
  SinglePostState get initialState => SinglePostUninitialized();

  @override
  Stream<SinglePostState> mapEventToState(SinglePostEvent event) async* {
    if (event is LoadSinglePost) {
      yield* _mapLoadSinglePostToState(event);
    }
  }

  Stream<SinglePostState> _mapLoadSinglePostToState(
      LoadSinglePost event) async* {
    _currentPostId = event.post.id;
    _currentPostGroupId = event.groupId;
    yield SinglePostLoaded(post: event.post, groupId: event.groupId);
  }

  @override
  Future<void> close() {
    _postSubscription?.cancel();
    return super.close();
  }
}
