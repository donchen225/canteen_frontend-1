import 'package:canteen_frontend/models/user/user.dart';
import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchCleared extends SearchEvent {}

class SearchStarted extends SearchEvent {
  final String identifier;

  const SearchStarted(this.identifier);

  @override
  List<Object> get props => [identifier];

  @override
  String toString() {
    return 'SearchStarted { identifier: $identifier }';
  }
}

class SearchInspectUser extends SearchEvent {
  final User user;

  const SearchInspectUser(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() {
    return 'SearchInspectUser { user: $user }';
  }
}

class ShowSearchResults extends SearchEvent {}
