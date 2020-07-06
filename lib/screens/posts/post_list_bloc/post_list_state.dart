import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/models/request/request.dart';
import 'package:equatable/equatable.dart';

abstract class PostListState extends Equatable {
  const PostListState();

  @override
  List<Object> get props => [];
}

class PostListUninitialized extends PostListState {}

class PostListLoading extends PostListState {}

class PostListLoaded extends PostListState {
  final String groupId;
  final List<DetailedPost> postList;

  const PostListLoaded({this.groupId, this.postList});

  @override
  List<Object> get props => [groupId, postList];

  @override
  String toString() {
    return 'PostListLoaded { groupId: $groupId }';
  }
}

class PostListUnauthenticated extends PostListState {}
