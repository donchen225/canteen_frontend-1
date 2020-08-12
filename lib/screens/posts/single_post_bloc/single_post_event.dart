import 'package:canteen_frontend/models/post/post.dart';
import 'package:equatable/equatable.dart';

abstract class SinglePostEvent extends Equatable {
  const SinglePostEvent();

  @override
  List<Object> get props => [];
}

class LoadSinglePost extends SinglePostEvent {
  final DetailedPost post;
  final String groupId;

  const LoadSinglePost({this.post, this.groupId});

  @override
  List<Object> get props => [post, groupId];

  @override
  String toString() => 'LoadSinglePost';
}
