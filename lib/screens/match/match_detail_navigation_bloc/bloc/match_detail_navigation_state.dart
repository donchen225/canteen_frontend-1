import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class MatchDetailNavigationState extends Equatable {
  const MatchDetailNavigationState();

  @override
  List<Object> get props => [];
}

class MatchNavigationUninitialized extends MatchDetailNavigationState {}

class CurrentIndexChanged extends MatchDetailNavigationState {
  final int currentIndex;

  CurrentIndexChanged({@required this.currentIndex});

  @override
  List<Object> get props => [currentIndex];

  @override
  String toString() => 'MatchDetailState to $currentIndex';
}

class PageLoading extends MatchDetailNavigationState {
  @override
  String toString() => 'PageLoading';
}

class ChatScreenLoaded extends MatchDetailNavigationState {
  ChatScreenLoaded();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'ChatScreenLoaded';
}

class VideoChatDetailScreenLoaded extends MatchDetailNavigationState {
  VideoChatDetailScreenLoaded();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'VideoChatDetailScreenLoaded';
}

class ProfileScreenLoaded extends MatchDetailNavigationState {
  ProfileScreenLoaded();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'ProfileScreenLoaded';
}
