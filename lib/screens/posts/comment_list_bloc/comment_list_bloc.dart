import 'dart:async';
import 'package:canteen_frontend/models/post/post_repository.dart';
import 'package:canteen_frontend/screens/posts/comment_bloc/bloc.dart';
import 'package:canteen_frontend/screens/posts/comment_list_bloc/comment_list_event.dart';
import 'package:canteen_frontend/screens/posts/comment_list_bloc/comment_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class CommentListBloc extends Bloc<CommentListEvent, CommentListState> {
  final CommentBloc _commentBloc;
  final PostRepository _postRepository;
  StreamSubscription _commentSubscription;
  String _currentPostId;

  CommentListBloc(
      {@required CommentBloc commentBloc,
      @required PostRepository postRepository})
      : assert(commentBloc != null),
        assert(postRepository != null),
        _commentBloc = commentBloc,
        _postRepository = postRepository {
    _commentSubscription = _commentBloc.listen((state) {
      if (state is CommentsLoaded) {
        final postId = state.postId;
        if (_currentPostId == postId) {
          add(UpdateCommentList(commentList: state.comments));
        }
      }
    });
  }

  @override
  CommentListState get initialState => CommentListUninitialized();

  @override
  Stream<CommentListState> mapEventToState(CommentListEvent event) async* {
    if (event is LoadCommentList) {
      yield* _mapLoadCommentListToState(event);
    } else if (event is UpdateCommentList) {
      yield* _mapUpdateCommentListToState(event);
    }
  }

  Stream<CommentListState> _mapLoadCommentListToState(
      LoadCommentList event) async* {
    final existingComments = _commentBloc.commentList[event.postId];
    if (existingComments != null) {
      yield CommentListLoaded(commentList: existingComments);
    } else {
      yield CommentListLoading();
    }
    _currentPostId = event.postId;

    _commentBloc
        .add(LoadComments(postId: event.postId, groupId: event.groupId));
  }

  Stream<CommentListState> _mapUpdateCommentListToState(
      UpdateCommentList event) async* {
    yield CommentListLoaded(commentList: event.commentList);
  }

  @override
  Future<void> close() {
    _commentSubscription?.cancel();

    return super.close();
  }
}
