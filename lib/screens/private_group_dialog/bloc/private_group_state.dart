import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class PrivateGroupState extends Equatable {
  const PrivateGroupState();

  @override
  List<Object> get props => [];
}

class PrivateGroupUninitialized extends PrivateGroupState {}

class PrivateGroupLoading extends PrivateGroupState {}

class PrivateGroupJoined extends PrivateGroupState {
  final String id;

  PrivateGroupJoined({this.id});

  @override
  List<Object> get props => [id];

  @override
  String toString() => 'PrivateGroupJoined { id: $id }';
}

class PrivateGroupJoinFailed extends PrivateGroupState {
  final String message;

  PrivateGroupJoinFailed({@required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'PrivateGroupJoinFailed { message: $message }';
}
