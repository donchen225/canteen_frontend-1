import 'package:canteen_frontend/models/post/post.dart';
import 'package:canteen_frontend/models/request/request.dart';
import 'package:equatable/equatable.dart';

abstract class SinglePostState extends Equatable {
  const SinglePostState();

  @override
  List<Object> get props => [];
}

class SinglePostUninitialized extends SinglePostState {}

class SinglePostLoading extends SinglePostState {}

class SinglePostLoaded extends SinglePostState {
  final DetailedPost post;
  final String groupId;

  const SinglePostLoaded({this.post, this.groupId});

  @override
  List<Object> get props => [post, groupId];

  @override
  String toString() {
    return 'SinglePostLoaded';
  }
}

class SinglePostUnauthenticated extends SinglePostState {}
